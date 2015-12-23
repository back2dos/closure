# closure

This library plugs in the google closure compiler into your build.

Usage in haxe builds:
  
```
-lib closure

# turn on advanced compilation:
-D closure_advanced

# turn on pretty printing:
-D closure_prettyprint

# overwrite original output rather then generating a .min.js next to it:
-D closure_overwrite

# change the level of debugging information:
-D closure_quiet
-D closure_verbose
```
