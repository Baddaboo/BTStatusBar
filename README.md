<img src="/Misc/loader.gif"/>
===
[WIP] A custom status bar + loader for iOS. Gradient added for dramatic effect.

<img src="/Misc/screen.gif" align="right">
## Usage
BTStatusBar can be used to present non-modal messages and and loading indicators without modifying the view hierarchy of an app.

- Add the files to your project
- Call `BTStatusBar.beginLoadingWithMessage` to present the status bar
- Set `BTStatusBar.loadingProgress` to the desired progress value (between 0 and 1)
- Set `BTStatusBar.message` to any desired message
- Call `BTStatusBar.hideLoadingWithMessage` to hide the status bar and remove it from the window heirarchy

## Disclaimer
This project is still very much a work-in-progress.
#### Known issues
- Sometimes Autolayout throws a threading warning when the status bar state is changed using GCD
- The `indeterminate` loading state isn't implemented. I'm debating over the design of that, both from a UI standpoint and architecture standpoint. If you have any thoughts on that, I'd greatly appreciate them!

## License
Licensed under the MIT License.
