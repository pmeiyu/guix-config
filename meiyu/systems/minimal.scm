(define-module (meiyu systems minimal))

(use-modules (gnu) (gnu packages))
(use-service-modules networking ssh)


(define %ssh-public-key
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSWDNLrevEMD83aVXEAoCirJxWxI1Ft5AlK15KipL+x")

(define %substitute-urls
  '("https://mirror.guix.org.cn"))

(operating-system
  (host-name "guix")
  (timezone "Asia/Shanghai")
  (locale "en_US.UTF-8")

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (target "/boot/efi")))

  ;; (initrd-modules (cons* ""
  ;;                        %base-initrd-modules))

  ;; Specify a mapped device for the encrypted root partition.
  (mapped-devices (list (mapped-device
                         (source "/dev/sda2")
                         ;; (source (uuid "00000000-0000-0000-0000-000000000000"))
                         (target "root")
                         (type luks-device-mapping))))

  (file-systems (cons* (file-system
                         (device "/dev/mapper/root")
                         (mount-point "/")
                         (type "btrfs")
                         (flags '(no-atime))
                         (dependencies mapped-devices))
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

  (packages (append (map (compose list specification->package+output)
                         '("curl" "nss-certs" "openssh" "rsync" "tmux"))
                    %base-packages))

  (services (cons* (service dhcp-client-service-type)
                   (service openssh-service-type
                            (openssh-configuration
                             (permit-root-login 'without-password)
                             (authorized-keys
                              `(("root" ,(plain-file "authorized_keys"
                                                     %ssh-public-key))))))
                   (modify-services %base-services
                     (guix-service-type
                      config => (guix-configuration
                                 (inherit config)
                                 (substitute-urls %substitute-urls)))))))
