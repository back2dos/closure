package closure;
import haxe.macro.Context;
import sys.FileSystem;

using StringTools;
using haxe.io.Path;

class Compiler {

  static function use() {
    #if !closure_disabled
    Context.onAfterGenerate(compile);
    #end
  }
  
  static function compile() {
    var out = haxe.macro.Compiler.getOutput();
    if (!out.endsWith('.js'))
       Context.warning('Expected .js extension for output file $out', Context.currentPos());
    
    var min = out.substr(0, out.length - 3) + '.min.js';
    
    var jar = Context.getPosInfos((macro null).pos).file.directory() + '/cli/compiler.jar';
    
    Sys.command('java', ['-jar', jar, 
      #if closure_prettyprint '--formatting=pretty_print', #end
      '--compilation_level', #if closure_advanced 'ADVANCED' #else 'SIMPLE' #end,
      '--js', out,
      '--js_output_file', min,
      #if closure_externs 
      '--externs',Context.definedValue("closure_externs"), 
      #end
      #if closure_language_in
      '--language_in',Context.definedValue("closure_language_in"),
      #end
      #if closure_warning_level
      '--warning_level',Context.definedValue("closure_warning_level"),
      #end
    ]);
    
    #if closure_overwrite
      FileSystem.deleteFile(out);
      FileSystem.rename(min, out);
    #end
  }
  
}
