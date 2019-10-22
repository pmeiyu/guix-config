;; Guix packages manifest file
;;
;; Install these packages by:
;; guix package -m packages.scm
;;

;; (define-module meiyu packages captain-packages)

(use-modules (gnu packages)
             (guix profiles)
             (meiyu packages collections))

(packages->manifest (append android-packages
                            archive-packages
                            command-line-packages
                            communication-packages
                            crypto-packages
                            desktop-packages
                            development-packages
                            emacs-packages
                            email-packages
                            file-transfer-packages
                            finance-packages
                            go-packages
                            monitor-packages
                            multimedia-packages
                            network-packages
                            office-packages
                            python-packages
                            virtual-machine-packages))
