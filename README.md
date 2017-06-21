# closure

This library plugs in the Google Closure Compiler into your build.

Usage in Haxe builds:
  
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


# disable closure compiler from being executed:
-D closure_disabled
```

### How to install

Closure is available on haxelib [lib.haxe.org/p/closure](https://lib.haxe.org/p/closure). To install:
```shell
haxelib install closure
```

The Google Closure Compiler requires Java Runtime Environment version 7+ to be installed.
