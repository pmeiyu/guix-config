(define-module (meiyu systems desktop)
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu system)
  #:use-module (gnu system nss)
  #:use-module (guix store)
  #:use-module (meiyu services dns)
  #:use-module (meiyu systems basic)
  #:use-module (srfi srfi-1))

(use-package-modules linux mail wm)
(use-service-modules desktop dns mail networking sddm web xorg)


(define %my-substitute-urls
  '("https://mirror.guix.org.cn"
    "https://ci.guix.org.cn"))

(define %resolv.conf
  (plain-file "resolv.conf"
              "nameserver ::1"))

(define-public %my-extra-desktop-packages
  (map (compose list specification->package+output)
       '("alsa-utils" "pulseaudio"
         "font-dejavu" "font-wqy-microhei" "font-awesome"
         "hicolor-icon-theme" "adwaita-icon-theme"
         "ibus" "ibus-rime" "librime" "dconf"
         "sway" "swayidle" "waybar" "rofi" "mako" "libnotify"
         "wl-clipboard" "grim" "slurp" "imv"
         "alacritty" "fish")))

(define-public %my-desktop-packages
  (append %my-basic-packages
          %my-extra-desktop-packages))

(define-public %my-base-desktop-services
  (cons*
   (service sddm-service-type)
   (modify-services
       ;; Remove GDM.
       (remove (lambda (service)
                 (eq? (service-kind service) gdm-service-type))
               %desktop-services)
     (guix-service-type
      config => (guix-configuration
                 (inherit config)
                 (substitute-urls %my-substitute-urls)
                 (extra-options '("--max-jobs=4"))))
     ;; Prevent network-manager from modifying /etc/resolv.conf.
     (network-manager-service-type
      config => (network-manager-configuration
                 (inherit config)
                 (dns "none"))))))

(define-public %my-extra-desktop-services
  (list
   (service dnscrypt-proxy-service-type)
   (simple-service 'resolv.conf etc-service-type
                   (list `("resolv.conf" ,%resolv.conf)))
   (service guix-publish-service-type
            (guix-publish-configuration (port 8181)))
   (service nginx-service-type
            (nginx-configuration
             (server-blocks
              (list (nginx-server-configuration
                     (server-name (list 'default))
                     (listen '("80"))
                     (root "/srv/www/default"))))))
   (service opensmtpd-service-type
            (opensmtpd-configuration
             (config-file (local-file "etc/mail/smtpd.conf"))))
   (screen-locker-service swaylock)
   (simple-service 'my-setuid-programs
                   setuid-program-service-type
                   (list (file-append brightnessctl "/bin/brightnessctl")))))

(define-public %my-desktop-services
  (append %my-base-desktop-services
          %my-extra-basic-services
          %my-extra-desktop-services))

(define-public %my-desktop-operating-system
  (operating-system
    (inherit %my-basic-operating-system)

    ;; Specify a mapped device for the encrypted root partition.
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

    ;; System-wide packages.
    (packages %my-desktop-packages)

    ;; Services.
    (services %my-desktop-services)

    ;; Allow resolution of '.local' host names with mDNS.
    (name-service-switch %mdns-host-lookup-nss)))
