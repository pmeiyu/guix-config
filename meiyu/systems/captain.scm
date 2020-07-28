(define-module (meiyu systems captain)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu system)
  #:use-module (guix store)
  #:use-module (meiyu packages linux-nonfree)
  #:use-module (meiyu services vpn)
  #:use-module (meiyu systems desktop))

(use-package-modules package-management)
(use-service-modules desktop nix security-token virtualization)

(define %packages
  %my-desktop-packages)

(define %services
  (cons*
   (bluetooth-service)
   (service gnome-desktop-service-type)
   (service libvirt-service-type)
   (service nix-service-type
            (nix-configuration
             (extra-config
              '("substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store/ https://cache.nixos.org/"))))
   (service pcscd-service-type)
   (service tinc-service-type
            (tinc-configuration (net-name "galaxy")))
   %my-desktop-services))

(operating-system
  (inherit %my-desktop-operating-system)
  (host-name "captain")

  ;; Mainline Linux kernel
  (kernel linux-nonfree)
  (kernel-arguments '())
  (firmware (cons* linux-firmware-nonfree
                   %base-firmware))

  (mapped-devices (list (mapped-device
                         (source "/dev/sda2")
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
                         (mount-point "/boot/efi")
                         (type "vfat"))
                       %base-file-systems))

  ;; (swap-devices '("/var/swapfile"))

  (packages %packages)

  (services %services))
