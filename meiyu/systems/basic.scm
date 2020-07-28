(define-module (meiyu systems basic)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu system)
  #:use-module (guix store)
  #:use-module (srfi srfi-1))

(use-package-modules bash shells)
(use-service-modules networking ssh sysctl)


(define %my-ssh-public-keys
  (string-join
   '("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSWDNLrevEMD83aVXEAoCirJxWxI1Ft5AlK15KipL+x"
     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGixg7L7vRFgmxBS2GmI4/UqPw7pERi3qbKFUPaEZIF")
   "\n"))

(define %my-substitute-urls
  (append %default-substitute-urls
          '("https://builder.pengmeiyu.com")))

(define-public %my-extra-basic-packages
  (append
   ;; Glibc provides /lib/ld-* for foreign apps.
   (list glibc)
   (map (compose list specification->package+output)
        '("btrfs-progs" "cryptsetup" "dosfstools" "ntfs-3g" "nftables"

          "bind:utils" "curl" "dbus" "emacs" "gash" "git" "gnupg"
          "guile-readline" "mcron" "ncurses" "nss-certs" "openssh" "pinentry"
          "python" "rsync" "stow" "tmux" "wget" "xdg-user-dirs" "xdg-utils"
          "zsh"))))

(define-public %my-basic-packages
  (append %base-packages
          %my-extra-basic-packages))

(define-public %my-base-services
  (modify-services %base-services
    (guix-service-type
     config => (guix-configuration
                (inherit config)
                (substitute-urls %my-substitute-urls)))))

(define-public %my-extra-basic-services
  (list
   (extra-special-file "/bin/bash"
                       (file-append bash "/bin/bash"))
   (extra-special-file "/lib"
                       "/run/current-system/profile/lib")
   (extra-special-file "/lib64"
                       "/run/current-system/profile/lib")
   (service nftables-service-type
            (nftables-configuration
             (ruleset (local-file "etc/nftables.conf"))))
   (service openssh-service-type
            (openssh-configuration
             (permit-root-login 'without-password)
             (password-authentication? #f)
             (authorized-keys
              `(("root" ,(plain-file "authorized_keys"
                                     %my-ssh-public-keys))
                ("meiyu" ,(plain-file "authorized_keys"
                                      %my-ssh-public-keys))))))
   (service sysctl-service-type
            (sysctl-configuration
             (settings '(("fs.inotify.max_user_watches" . "100000")
                         ("net.core.default_qdisc" . "fq")
                         ("net.ipv4.tcp_congestion_control" . "bbr")))))))

(define-public %my-basic-services
  (append %my-base-services
          %my-extra-basic-services))

(define-public %my-basic-operating-system
  (operating-system
    (host-name "guix")
    (timezone "Asia/Shanghai")
    (locale "en_US.UTF-8")

    ;; EFI bootloader
    (bootloader (bootloader-configuration
                 (bootloader grub-efi-bootloader)
                 (target "/boot/efi")))

    ;; ;; Kernel
    ;; (kernel linux-nonfree)
    ;; (kernel-arguments '())
    ;; (firmware (cons* linux-firmware-nonfree
    ;;                  %base-firmware))
    ;; (initrd-modules (cons* ""
    ;;                        %base-initrd-modules))

    (file-systems
     (cons* (file-system
              ;; (device (uuid "00000000-0000-0000-0000-000000000000"))
              (device "/dev/sda2")
              (mount-point "/")
              (type "btrfs")
              (flags '(no-atime)))
            (file-system
              (device "/dev/sda1")
              ;; (device (uuid "0000-0000" 'fat))
              (mount-point "/boot/efi")
              (type "vfat"))
            (file-system
              (mount-point "/tmp")
              (device "none")
              (type "tmpfs")
              (check? #f))
            %base-file-systems))

    ;; (swap-devices '("/var/swapfile"))

    (users (cons* (user-account
                   (name "meiyu")
                   (uid 1000)
                   (comment "Peng Mei Yu")
                   (group "users")
                   (supplementary-groups '("audio" "input" "kvm" "lp"
                                           "netdev" "video" "wheel"))
                   (shell (file-append zsh "/bin/zsh")))
                  %base-user-accounts))

    ;; System-wide packages.
    (packages %my-basic-packages)

    ;; Services.
    (services %my-basic-services)))
