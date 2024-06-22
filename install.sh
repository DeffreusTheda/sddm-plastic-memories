#!/bin/sh
set -eux

THEMEPATH="/usr/share/sddm/themes/sddm-plastic-memories"

#: 1. Copy theme files to `/usr/share/sddm/themes/sddm-plastic-memories/` directory
sudo cp -r sddm-plastic-memories $THEMEPATH

#: 2. Automatically edit `/etc/sddm.conf` to use this theme
sed -i 's:Current=.*:Current=sddm-plastic-memories:' /etc/sddm.conf

#: 3. Add read and write permission for `theme.conf.user`
sudo chmod +666 $THEMEPATH/theme.conf.user

#: 4. Open `theme.conf.user` with `$EDITOR` or `vi` as fallback
if ! ${EDITOR:?'EDITOR environment variable not set!'} $THEMEPATH/theme.conf.user; then
	vi $THEMEPATH/theme.conf.user
fi
