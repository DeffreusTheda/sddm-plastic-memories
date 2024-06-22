# SDDM Plastic Memories Theme

<div align="center"><img src="preview.png" alt="preview"></div>

> [!IMPORTANT]
> This is an unofficial theme.<br>
> I do not own the opening video and music, nor the title images.<br>
> This theme will be removed if the copyright holders requested so.

A SDDM theme inspired by 2015 Anime ["Plastic Memories"](https://en.wikipedia.org/wiki/Plastic_Memories)

You can watch the preview video [here](preview.mp4) (WIP)

## Installation

Dependencies:

- [`sddm`](https://github.com/sddm/sddm)
- `qt5-multimedia`
- `qt5-quickcontrols`
- .webm audio and video codecs

```sh
#: Clone this theme
git clone https://github.com/DeffreusTheda/sddm-plastic-memories

#: Run installer
./sddm-plastic-memories/install.sh
```

What `install.sh` does:

1. Copy theme files to `/usr/share/sddm/themes/sddm-plastic-memories/` directory
2. Automatically edit `/etc/sddm.conf` to use this theme
3. Add write permission for `theme.conf.user`
4. Open `theme.conf.user` with `$EDITOR` or `vi` as fallback

> [!NOTE]
> Please enter your `sudo` password whenever asked

Thank you for using this theme! ^-^

## Configuration

Edit `/usr/share/sddm/themes/sddm-plastic-memories/theme.conf.user` after installation

```sh
$EDITOR /usr/share/sddm/themes/sddm-plastic-memories/theme.conf.user
```

## Preview/Testing

Run the `test.sh` file

```sh
/usr/sha/sddm/themes/sddm-plastic-memories/test.sh
```

## Issues or Bugs ?!

Please [open an issue](https://github.com/DeffreusTheda/sddm-plastic-memories/issues/new), describing your problem with relevant images, logs, or other source of information.

## Developer "Note"

<details><summary>A bit of rant...</summary>
	This theme is a fork of https://github.com/lll2yu/sddm-lain-wired-theme by lll2yu, btw.
	It gotten to the point that it's not a fork anymore, I think (?).
	I spent 3 (holi)days to make this all.
	Before this, I shared my Isla themed desktop setup in a Discord server, but nobody really liked it.
	I don't know, I don't felt enough, so here I am with this SDDM theme.
	It turned out pretty good though, amirite?
	Got paranoid with copyright infringement at day 2, but I don't think Doga Kobo really care (I hope so @_@).
	Y291bGQgeW91IHBsZWFzZSBjdXJlIG15IGxvbmVsaW5lc3MgYWFhYWFhYWFhYWFhYWFhYWFhYWEK
	plase help
</details>
>>>>>>> abbe5d5 (Version 0.1.0)
