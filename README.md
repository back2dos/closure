# closure

This library plugs in the google closure compiler into your build.

Usage in haxe builds:
  
```shell
-lib closure

# turn on advanced compilation:
-D closure_advanced

# turn on pretty printing:
-D closure_prettyprint

# overwrite original output rather then generating a .min.js next to it
-D closure_overwrite

# optional. set specific ecmascript version:
-D closure_language_in=ECMASCRIPT5

# set warning level. Can be DEFAULT, VERBOSE or QUIET.
-D closure_warning_level=QUIET
```
