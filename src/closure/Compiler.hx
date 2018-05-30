package closure;
import haxe.macro.Context;
import sys.FileSystem;

using StringTools;
using haxe.io.Path;
import sys.io.File;

class Compiler {

  static function use() {
    #if (!closure_disabled && !closure_slavemode)
    Context.onAfterGenerate(compile);
    #end
  }

  static function removeSourceMapLine( inputpath, outputpath ) {
    var input = File.read(inputpath);
    var output = File.write(outputpath);
    var regex = ~/^\/\/[@#] ?sourceMappingURL=.+$/;
    while( ! input.eof() )
    {
      var line = input.readLine();
      if( regex.match(line) )
        continue;
      else
        output.writeString( line + "\n" );
    }
    input.close();
    output.close();
  }

  static function compile() {
    var out = haxe.macro.Compiler.getOutput();
    if (!out.endsWith('.js'))
       Context.warning('Expected .js extension for output file $out', Context.currentPos());

    var map = Context.definedValue("closure_create_source_map");

    compileFile(out, map);
  }

  static public function compileFile( path: String, map: String ) {
    var min = path.substr(0, path.length - 3) + '.min.js';

    var jar = Context.getPosInfos((macro null).pos).file.directory() + '/cli/compiler.jar';

    var tmp = path;
    #if closure_create_source_map
      tmp += ".tmp";
      removeSourceMapLine( path, tmp );
    #end

    Sys.command('java', ['-jar', jar,
      #if closure_prettyprint '--formatting=pretty_print', #end
      '--compilation_level', #if closure_advanced 'ADVANCED' #else 'SIMPLE' #end,
      '--js', tmp,
      '--js_output_file', min
      #if closure_externs
      , '--externs',Context.definedValue("closure_externs")
      #end
      #if closure_language_in
      , '--language_in',Context.definedValue("closure_language_in")
      #end
      #if closure_warning_level
      , '--warning_level',Context.definedValue("closure_warning_level")
      #end
      #if closure_create_source_map
      , '--create_source_map', map
      #end
    ]);

    #if closure_overwrite
      FileSystem.deleteFile(path);
      FileSystem.rename(min, path);
    #end

    #if closure_create_source_map
    {
      FileSystem.deleteFile(tmp);
      var output = File.append(min);
      output.writeString('\n//# sourceMappingURL=${map.split('/').pop()}');
      output.close();
    }
    #end
  }

}
