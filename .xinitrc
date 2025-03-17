#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export _JAVA_AWT_WM_NONREPARENTING=1

xsetroot -cursor_name left_ptr

xset -b

xrdb -merge ~/.Xresources

if [ "$HOST" -eq "archi" ]; then
    xrandr --output 'eDP-1' --mode '2880x1800' --scale '0.75x0.75' --dpi '120'
elif [ "$HOST" -eq "rchy" ]; then
    xrandr --output 'DP-2' --mode '3440x1440' --pos '0x0' --rotate 'normal' --output 'DP-4' --mode '1920x1080' --pos '3440x0' --rotate 'normal'
fi


# i3-gaps
exec i3
