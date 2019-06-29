#!/bin/bash
pac=0 #$(checkupdates | wc -l)
aur=0 #$(aurcheck -d custom | wc -l)

check=$((pac + aur))
if [[ "$check" != "0" ]]
then
    echo "$pac %{F#5b5b5b}%{F-} $aur"
fi
