(define-module (meiyu systems dinosaur)
  #:use-module (gnu)
  #:use-module (gnu system)
  #:use-module (guix store)
  #:use-module (meiyu services vpn)
  #:use-module (meiyu systems desktop))

(use-service-modules spice)


(define %my-substitute-urls
  '("http://mirror.lan/guix"
    "http://builder.lan/guix"))

(define %my-services
  (cons*
   (service spice-vdagent-service-type (spice-vdagent-configuration))
   (service tinc-service-type
            (tinc-configuration (net-name "galaxy")))
   (modify-services
       %my-desktop-services
     (guix-service-type
      config => (guix-configuration
                 (inherit config)
                 (substitute-urls %my-substitute-urls))))))

(operating-system
  (inherit %my-desktop-operating-system)
  (host-name "dinosaur")

  (mapped-devices (list (mapped-device
                         (source "/dev/vda2")
                         (target "root")
                         (type luks-device-mapping))))

  (file-systems (cons* (file-system
                         (device "/dev/mapper/root")
                         (mount-point "/")
                         (type "btrfs")
                         (flags '(no-atime))
                         (dependencies mapped-devices))
                       (file-system
                         (device "/dev/vda1")
                         (mount-point "/boot/efi")
                         (type "vfat"))
                       %base-file-systems))

  (services %my-services))
