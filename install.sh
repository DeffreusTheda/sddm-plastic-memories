#!/bin/sh
set -x

infodt() {
	echo $(tput setaf $1)$2$(tput sgr0)
}

THEMEPATH="/usr/share/sddm/themes/sddm-plastic-memories"

#: 1. Download the opening video from Git LFS
infodt 3 "[STATUS] Downloading the opening video from Git LFS..."
git lfs install >/dev/null
if git lfs pull >/dev/null; then
	infodt 2 "[SUCCESS] Downloaded the opening video from Git LFS!"
else
	infodt 1 "[ERROR] Unknown error executing: git lfs pull"
fi

#: 2. Copy theme files to `/usr/share/sddm/themes/sddm-plastic-memories/` directory
infodt 3 "[STATUS] Copying files to $THEMEPATH..."
infodt 6 "[INFO] Please enter your sudo password whenever asked~"
if [[ ! -d $THEMEPATH ]] || rmdir $THEMEPATH; then
	sudo mkdir -p $THEMEPATH
else
	infodt 1 "[ERROR] $THEMEPATH directory already exist?!"
	infodt 6 "[INFO] Please delete or empty it~"
	infodt 3 "[STATUS] Exiting..."
	exit 1
fi
if sudo cp -r * $THEMEPATH; then
	infodt 2 "[SUCCESS] Copied theme files to $THEMEPATH directory!"
else
	infodt 1 "[ERROR] Unknown error executing: sudo cp -r * $THEMEPATH"
	exit 1
fi

#: 3. Automatically edit `/etc/sddm.conf` to use this theme
infodt 3 "[STATUS] Editing /etc/sddm.conf to use this theme..."
if [[ ! -f /etc/sddm.conf ]] || [[ -z $(cat /etc/sddm.conf) ]]; then
	sudo rm /etc/sddm.conf 2>/dev/null
	sudo touch /etc/sddm.conf
	echo -e "[Theme]\nCurrent=sddm-plastic-memories" | sudo tee /etc/sddm.conf >/dev/null
elif sudo sed -i 's:Current=.*:Current=sddm-plastic-memories:' /etc/sddm.conf; then
	infodt 2 "[SUCCESS] Edited /etc/sddm.conf to use this theme!"
else
	infodt 1 "[ERROR] Unknown error executing: sed -i 's:Current=.*:Current=sddm-plastic-memories:' /etc/sddm.conf"
	exit 1
fi

#: 4. Add read and write permission for `theme.conf.user`
infodt 3 "[STATUS] Adding read and write permission for theme.conf.user..."
if sudo chmod +666 $THEMEPATH/theme.conf.user; then
	infodt 2 "[SUCCESS] Added read and write permission for theme.conf.user!"
else
	infodt 1 "[ERROR] Unknown error executing: sudo chmod +666 $THEMEPATH/theme.conf.user"
	exit 1
fi

#: 5. Open `theme.conf.user` with `$EDITOR` or `vi` as fallback
infodt 3 "[STATUS] Opening theme.conf.user with $EDITOR or vi as fallback..."
infodt 6 "[INFO] Configure as you like! Proceed?"
read -p "Confirm (Y/n) " CONF
if [[ ${CONF:-Y} =~ ^[Nn] ]]; then
	infodt 3 "[STATUS] Aborting editing theme.conf.user..."
elif ! ${EDITOR:?$(tput setaf 1)'[ERROR] EDITOR env not set!'} $THEMEPATH/theme.conf.user; then
	vi $THEMEPATH/theme.conf.user
fi

infodt 2 "[SUCCESS] Installation successful!"
exit 0 #: Success! Yeay!
