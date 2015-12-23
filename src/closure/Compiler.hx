package closure;
import haxe.macro.Context;
import sys.FileSystem;

using StringTools;
using haxe.io.Path;

class Compiler {

  static function use() 
    Context.onAfterGenerate(compile);
  
  static function compile() {
    var out = haxe.macro.Compiler.getOutput();
    if (!out.endsWith('.js'))
      Context.error('Expected .js extension for output file $out', Context.currentPos());
    
    var min = out.substr(0, out.length - 3) + '.min.js';
    
    var jar = Context.getPosInfos((macro null).pos).file.directory() + '/cli/compiler.jar';
    
    Sys.command('java', ['-jar', jar, 
      #if closure_prettyprint '--formatting=pretty_print', #end
      '--compilation_level', #if closure_advanced 'ADVANCED' #else 'SIMPLE' #end,
      '--js', out,
      '--js_output_file', min,
      #if closure_quiet '--warning_level', 'QUIET', #end
      #if closure_verbose '--warning_level', 'VERBOSE', #end
    ]);
    
    #if closure_overwrite
      FileSystem.deleteFile(out);
      FileSystem.rename(min, out);
    #end
  }
  
}
