## Demos
A basic demo using tdrop to create a dropdown/scratchpad on the fly with a hotkey. I set the height to be less than max with tdrop to make it more obvious which is the dropdown at which time. First apvlv is turned into a dropdown. Then it is cleared and zathura is turned into a dropdown. One can also have multiple hotkeys to create multiple dropdowns on the fly at a time.
![Alt text](http://angelic-sedition.github.io/tdrop/assets/on_the_fly.gif "On the fly creation")

A demo showing tdrop's ability to auto-hide windows when opening things from them. First an image is opened in sxiv from ranger in the dropdown. When sxiv is closed, the dropdown automatically re-appears. The image is opened once again, but this time the dropdown is manually toggled before closing sxiv. This cancels the "re-show".
![Alt text](http://angelic-sedition.github.io/tdrop/assets/auto_hide.gif "Auto Hiding")

## Advantages Over Other Dropdown Terminals
- Can be used with any terminal or other program of your choice
- Allows turning any window into a dropdown on the fly
- Allows for control of sizing and initial placement so that panels aren't hidden
- Supports tiled and floating dropdowns
- Attempts to deal with floating windows on a case by case basis (ability to have a floating dropdown without needing a rule to float all windows of that type)
- Allows for multiple dropdowns of the same type (works by window id)
- Allows for auto-hiding a dropdown when opening programs from it
- Can automatically start programs and tmux or tmuxinator sessions

## Requirements
- xprop
- xwininfo
- xdotool
- tmux (optional)
- tmuxinator (optional)

## Installation Instructions and Usage
Tdrop is in the AUR as `tdrop-git`. It can also be installed by cloning this repo and running `sudo make install`. One can then bind a key to it, e.g. with sxhkd:

```
alt + s
	tdrop -a -w 1362 -y 14 -s dropdown termite
```

Refer to `tdrop --help` and the manpage for more complete instructions.

## Tested With
### Terminals
- Termite
- URxvt
- XTerm
- Xfce4-terminal
- Gnome-terminal
- Konsole
- Terminology
- Sakura
- Roxterm

If your terminal doesn't work with tdrop, feel free to make an issue.

### Window Managers
The primary goal of tdrop is to "just work" with any window manager. The primary differences between how tdrop deals with different window managers is the strategy it takes for floating only the dropdown (as opposed to all instances of the class that the dropdown is) and how it deals with window managers that resize or move a window after mapping then unmapping it. There are three types of window managers as far as tdrop is concerned.

#### Tiling without Floating Support
If your window manager does not support floating, there's nothing to worry about. Binding a key to `tdrop <settings> term` should work. Options for resizing and movement that work only with floating window managers are not supported. One can, however, add post-map and post-unmap commands to do something like change the layout to fullscreen when showing a dropdown then revert the layout when hiding the dropdown. Automatic settings exist to do this for the following (use '-a'):
- herbstluftwm

#### Floating/Stacking
For floating window managers, tdrop should also generally "just work", but you will need to add the '-a' option. Many floating window managers will either center or resize a window when mapping then unmapping it. Tdrop provides for a `--post-commmand` to deal with this. '-a' will automatically determine the proper post command to use for your window manager if one exists. The '-a' option will also set things up so that window geometry/position will be properly restored on an `auto_show`.

That said, these are the floating window managers that currently have '-a' settings:
- xfwm4
- metacity
- openbox
- pekwm
- fluxbox
- blackbox
- fvwm
- sawfish
- goomwwm

Usually, it is a simple matter to add new ones to this list. If your dropdown moves out of place when being shown, make an issue, and I will add settings for it.

#### Tiling with Floating Support
These window managers currently will work with '-a' for a floating (instead of tiled) dropdown.
- bspwm
- i3
- awesome

Awesome support may be buggy; if you encounter problems, please report them. Unmapping behaviour is different on awesome for some reason, so tdrop will act different when the dropdown is open on another workspace/tag (first call will unmap it and the second will map it on the current tag).

## Why Not Use wmctrl?
Necessary features don't work on many window managers, including mine.

## Why Not Use wmutils?
Maybe in the future. The only advantage I can see over xdotool is that it can toggle mapping (`mapw -t`), but this wouldn't be used in this script anyway since different code is executed depending on whether or not the window is mapped or unmapped. Also the command names are somewhat cryptc and resizing to a percentage isn't supported (would have to convert percentages to pixels).

## Similar:
- [drawer](https://github.com/lharding/lsh-bin/blob/master/drawer)
