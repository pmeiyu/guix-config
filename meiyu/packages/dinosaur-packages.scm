;; Guix packages manifest file
;;
;; Install these packages by:
;; guix package -m packages.scm
;;

;; (define-module meiyu packages dinosaur-packages)

(use-modules (gnu packages)
             (guix profiles)
             (meiyu packages collections))

(packages->manifest (append archive-packages
                            command-line-packages
                            communication-packages
                            crypto-packages
                            desktop-packages
                            development-packages
                            emacs-packages
                            email-packages
                            file-transfer-packages
                            firefox-dependencies
                            go-packages
                            monitor-packages
                            network-packages
                            python-packages))
