# [insight](http://iamnoah.com/insight)
![OS X](http://mac.github.com/images/apple.png)
> catch every login moment

Insight is a small script that takes a snapshot each time it detects a wake or login attempt
- Catch whoever is trying to get into your mac *red-handed*!
- Build a collection of unsuspecting self-shots
- Fork this and do something else on each insight (see: `bin/onInsight`)
- Automatically share to Dropbox: `cd ~/Dropbox && ln -s ~/insight/saw insight`

## Quick Start
1. ⌘+space (Spotlight)
2. Type `Terminal` and press return
3. Paste (right-click) into the Terminal window:

```shell
curl https://raw.github.com/magus/insight/master/install.sh | bash
```
That's it, you're done!

## Locations
- Everything is saved in `/Users/<username>/insight/`
- Screenshots are located under `/Users/<username>/insight/saw/`
- Output and errors are located within `/Users/<username>/insight/log/`

## Issues
Please open a [new issue](https://github.com/magus/insight/issues/new) if
you encounter any issues during the installation process or everyday use
of this tool.

## License
© 2013 "magus"  
Licensed under the MIT license.  
<http://twitter.com/magusnn>

