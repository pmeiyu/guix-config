(define-module (meiyu packages collections)
  :use-module (gnu)
  :use-module (gnu packages))


(define-public android-packages
  (map (compose list specification->package+output)
       '("adb"
         "fastboot")))

(define-public archive-packages
  (map (compose list specification->package+output)
       '("ddrescue"
         "lzip"
         "lziprecover"
         "p7zip"
         "par2cmdline"
         "tar"
         "unzip"
         "zip"
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
       '("cryptsetup"
         "encfs"
         "openssl")))

(define-public desktop-packages
  (map (compose list specification->package+output)
       '("anki"
         "keepassxc"
         "nyxt")))

(define-public development-packages
  (map (compose list specification->package+output)
       '("gettext"
         "git"
         "git:send-email"
         "make"
         "perl"
         "sharutils"
         "strace")))

(define-public emacs-packages
  (map (compose list specification->package+output)
       '("aspell"
         "aspell-dict-en"
         "emacs"
         "emacs-pdf-tools"
         "emacs-rime")))

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
         "socat"
         "tcpdump")))

(define-public office-packages
  (map (compose list specification->package+output)
       '("libreoffice"
         "obs")))

(define-public python-packages
  (map (compose list specification->package+output)
       '("ptpython"
         "python"
         "python-ipython"
         "python-language-server"
         "python-matplotlib"
         "python-numpy"
         "python-pandas"
         "python-peewee"
         "python-pillow"
         "python-pytz"
         "python-requests"
         "python-virtualenv")))

(define-public virtual-machine-packages
  (map (compose list specification->package+output)
       '("ovmf"
         "qemu"
         "virt-viewer")))
