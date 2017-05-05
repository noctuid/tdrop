## Demos
A basic demo using tdrop to create a dropdown/scratchpad on the fly with a hotkey. I set the height to be less than max with tdrop to make it more obvious which is the dropdown at which time. First apvlv is turned into a dropdown. Then it is cleared and zathura is turned into a dropdown. One can also have multiple hotkeys to create multiple dropdowns on the fly at a time.
![Alt text](http://noctuid.github.io/tdrop/assets/on_the_fly.gif "On the fly creation")

A demo showing tdrop's ability to auto-hide windows when opening things from them. First an image is opened in sxiv from ranger in the dropdown. When sxiv is closed, the dropdown automatically re-appears. The image is opened once again, but this time the dropdown is manually toggled before closing sxiv. This cancels the "re-show".
![Alt text](http://noctuid.github.io/tdrop/assets/auto_hide.gif "Auto Hiding")

## Advantages Over Other Dropdown Terminals
- Can be used with any terminal or other program of your choice
- Allows turning any window into a dropdown on the fly
- Allows for control of sizing and initial placement so that panels aren't hidden
- Supports tiled and floating dropdowns
- Attempts to deal with floating windows on a case by case basis (ability to have a floating dropdown without needing a rule to float all windows of that type)
- Allows for multiple dropdowns of the same type (works by window id)
- Allows for auto-hiding a dropdown when opening programs from it
- Can automatically start programs and tmux or tmuxinator sessions
- Supports automatic resizing based on the current monitor
- Has hooks for executing user commands

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

### Basic Flags
`-s` should only be used for supported terminals and if the user wants to start a tmux or tmuxinator session. `-a` should be used to set up WM specific rules (which are required for the --width, --height, --xoff, and --yoff flags to work properly; see below for supported WMs). Refer to `tdrop --help` and the manpage for more complete instructions.

Tdrop has basic checks to print errors for malformed commands (for example to require one positional argument). If a tdrop command does not work, please run it in a terminal or check `/tmp/tdrop/log` for error messages and consult the manpage before making an issue.

**Changes**:

Long options can now be used with whitespace instead of requiring a `=` (e.g. `--long-opt value`).

Old users please note that `-W|--normal-window`, `-z|--sleep-terminal`, and `-Z|--sleep-window` are no longer necessary and have been removed.

### Flicker
For some window managers that require a window to be repositioned after re-mapping it, some flicker may be noticeable. With a recent change, this flicker is pretty much gone for some window managers (e.g. in the Gnome Shell and Cinnamon DEs) and slightly better than before in other
s. It is usually worse on tiling managers where the window must be re-floated every time it is mapped. The way around this is to use rules to either always have the class floated or one-time rules to only float the next instance of a class. For example, since bspwm has oneshot rules and won't alter the size/position of a window, this flicker is not a problem.

However, the consistent way to eliminate visual flickering due to moving/resizing for any window manager is to enable fade-in for the compositor. For compton this can be done by setting `fading = true;` and adjusting the `fade-delta` in the .compton.conf accordingly.

### Monitor Awareness
Using the `-m`/`--monitor-aware` flag will cause the geometry options to act with respect to the current monitor. This may be helpful for users of multiple monitors who don't want dropdowns spanning across monitors.

This is particularly useful when using a percentage or negative value with `-w`, `-h`, `-x`, and/or `-y`. For example, `-w -4` normally corresponds to a width 4 pixels less than 100% of the screen width (potentially the combined width of multiple monitors). With `-m`, the pixel values are calculated using the dimensions of the current monitor alone. Negative values may be useful when the window manager (possibly due to window decorations) causes a dropdown with `-w 100%` to go over the edge of the screen. The `-m` option will also automatically resize and/or reposition the dropdown when opening it on a different monitor when one or more of the geometry arguments are negative or percentages.

Some window managers allow querying what the current monitor is (e.g. bspwm and i3), but for other window managers, tdrop determines the current monitor based on the position of the active window. For these window managers, if the desktop is empty, tdrop must wait for the dropdown to be created or mapped before getting the monitor info. This may cause a slight delay before the dropdown is properly resized. If `-m` does not work at all or there is a specific way to query for the current monitor in your window manager, please make an issue.

See the manpage for more information.

### Hooks
Tdrop provides a `--create-hook` flag that can be used to run a command after first creating a dropdown. This hook will run for a normal dropdown or when the current window is turned into a dropdown. There is also a `--map-hook` flag that will run a command every time a dropdown is mapped. This hook will run when first creating a normal dropdown but not when turning the current window into a dropdown (since it is initially unmapped not mapped).

A `$1` in the given command will be replaced with the window id for the dropdown (in this case the command will of course need to be in single quotes or the dollar sign escaped). For example, to set a dropdown as always on top, `--map-hook 'wmctrl -i -r $1 -b add,above'` could be added to a tdrop command.

I plan to remove the current `-p`, `-P`, `-M`, and `-O` flags and replace them with generic hooks. Currently these options are only useful for dealing with floating/moving/resizing as they override settings made by `-a`. After this change, the new settings will still be able to be used for this purpose, but the idea is to have tdrop deal with these things automatically using `-a`. I will also provide a way to have the settings for another window manager be used as a simpler initial workaround for tdrop not yet having settings for some window manager.

### Auto-hiding
In addition to creating dropdowns, tdrop can automatically hide a window and later un-hide it. For example, if gvim is opened to write a git commit message from the terminal, tdrop can automatically hide the terminal (dropdown or not) and restore it after the user is finished writing the commit message:

```
hide_on_open() {
	tdrop -a auto_hide && "$@" && tdrop -a auto_show
}
alias gc='hide_on_open git commit'
```

The most useful application of this functionality is probably when opening videos, images, etc. in an external program from a file manager like ranger. For example, in the `rifle.conf`:
```
mime ^video, has mpv, X, flag f = tdrop -a auto_hide && mpv -- "$@" && tdrop -a auto_show
```

## Tested With
### Terminals
- Termite
- URxvt (including urxvtd)
- XTerm
- Xfce4-terminal
- Gnome-terminal
- Konsole
- Terminology
- Sakura
- Roxterm
- Terminix (-s will not work if the terminix process is already running)
- st

If your terminal doesn't work with tdrop, feel free to make an issue.

### Window Managers
The primary goal of tdrop is to "just work" with any window manager. The primary differences between how tdrop deals with different window managers is the strategy it takes for floating only the dropdown (as opposed to all instances of the class that the dropdown is) and how it deals with window managers that resize or move a window after unmapping then mapping it. There are three types of window managers as far as tdrop is concerned.

#### Tiling without Floating Support
If your window manager does not support floating, there's nothing to worry about. Binding a key to `tdrop <settings> term` should work. Options for resizing and movement that work only with floating window managers are not supported. One can, however, add post-map and post-unmap commands to do something like change the layout to fullscreen when showing a dropdown then revert the layout when hiding the dropdown. Automatic settings exist to do this for the following (use '-a'):
- herbstluftwm

#### Floating/Stacking
For floating window managers, tdrop should also generally "just work", but you will need to add the '-a' option. Many floating window managers will either center or resize a window when mapping then unmapping it. Tdrop provides for a `--post-commmand` to deal with this. '-a' will automatically determine the proper post command to use for your window manager if one exists. The '-a' option will also set things up so that window geometry/position will be properly restored on an `auto_show`.

That said, these are the floating window managers that currently have '-a' settings:
- mutter (gnome shell)
- muffin (cinnamon)
- xfwm4 (xfce)
- metacity (gnome 2)
- marco (mate)
- kwin (kde)
- openbox (lxde)
- compiz (unity)
- pekwm
- fluxbox
- blackbox
- fvwm
- sawfish
- goomwwm

Usually, it is a simple matter to add new ones to this list. If your dropdown moves out of place when being shown, make an issue, and I will add settings for it.

#### Tiling with Floating Support
These window managers currently will work with '-a' for a floating (instead of tiled) dropdown.
- bspwm (support for versions prior to 0.9.1 was dropped on 2016/09/22)
- i3
- awesome

Awesome support may be buggy; if you encounter problems, please report them. Unmapping behaviour is different on awesome for some reason, so tdrop will act different when the dropdown is open on another workspace/tag (first call will unmap it and the second will map it on the current tag).

## Why Not Use wmctrl?
Necessary features don't work on many window managers, including mine.

## Why Not Use wmutils?
Maybe in the future. The only advantage I can see over xdotool is that it can toggle mapping (`mapw -t`), but this wouldn't be used in this script anyway since different code is executed depending on whether or not the window is mapped or unmapped. Also the command names are somewhat cryptic.

## Similar:
- [drawer](https://github.com/lharding/lsh-bin/blob/master/drawer)
