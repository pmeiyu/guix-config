(define-module (meiyu packages collections)
  :use-module (gnu)
  :use-module (gnu packages))


(define-public android-packages
  (map (compose list specification->package+output)
       '("adb"
         "fastboot")))

(define-public archive-packages
  (map (compose list specification->package+output)
       '("duplicity"
         "lzip"
         "lziprecover"
         "p7zip"
         "par2cmdline"
         "plzip"
         "tar"
         "zstd"
         "zutils")))

(define-public command-line-packages
  (map (compose list specification->package+output)
       '("autossh"
         "cowsay"
         "espeak-ng"
         "fd"
         "file"
         "go-github-com-junegunn-fzf"
         "graphviz"
         "jq"
         "mosh"
         "parallel"
         "progress"
         "pv"
         "ripgrep"
         "sl"
         "stow"
         "tree")))

(define-public communication-packages
  (map (compose list specification->package+output)
       '("pidgin"
         "weechat")))

(define-public crypto-packages
  (map (compose list specification->package+output)
       '("encfs"
         "openssl")))

(define-public desktop-packages
  (map (compose list specification->package+output)
       '("anki"
         "icecat"
         "keepassxc"
         "next")))

(define-public development-packages
  (map (compose list specification->package+output)
       '("gettext"
         "git"
         "git:send-email"
         "perl"
         "sharutils"
         "strace")))

(define-public emacs-packages
  (map (compose list specification->package+output)
       '("aspell"
         "aspell-dict-en"
         "emacs"
         "emacs-pdf-tools")))

(define-public email-packages
  (map (compose list specification->package+output)
       '("msmtp"
         "mu"
         "offlineimap"
         "python2-pysocks")))

(define-public file-transfer-packages
  (map (compose list specification->package+output)
       '("aria2"
         "deluge"
         "go-ipfs"
         "rclone"
         "rsync"
         "syncthing")))

(define-public finance-packages
  (map (compose list specification->package+output)
       '("electrum"
         "gnucash"
         "ledger")))

(define-public firefox-bin-dependencies
  (map (compose list specification->package+output)
       '("gcc:lib"
         "libxcomposite"
         "libxt")))

(define-public go-packages
  (map (compose list specification->package+output)
       '("go")))

(define-public java-packages
  (map (compose list specification->package+output)
       '("maven"
         "openjdk")))

(define-public monitor-packages
  (map (compose list specification->package+output)
       '("htop"
         "iftop"
         "iotop"
         "lsof"
         "powertop"
         "smartmontools")))

(define-public multimedia-packages
  (map (compose list specification->package+output)
       '("ffmpeg"
         "imagemagick"
         "mkvtoolnix"
         "mpd"
         "mpd-mpc"
         "ncmpcpp"
         "vlc"
         "youtube-dl")))

(define-public network-packages
  (map (compose list specification->package+output)
       '("badvpn"
         "bind:utils"
         "iodine"
         "mtr"
         "ngrep"
         "nmap"
         "openvpn"
         "socat"
         "tcpdump")))

(define-public office-packages
  (map (compose list specification->package+output)
       '("libreoffice")))

(define-public python-packages
  (map (compose list specification->package+output)
       '("ptpython"
         "python"
         "python-language-server"
         "python-pytz"
         "python-requests")))

(define-public virtual-machine-packages
  (map (compose list specification->package+output)
       '("ovmf"
         "qemu"
         "virt-viewer")))
