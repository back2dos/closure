package;

class Main {

  static function main() untyped {
    var content:String = require('fs')['readFileSync'](__filename).toString();
    
    var methodsRenamed = content.indexOf('main') == -1;
    var classesRenamed = content.indexOf('Main') == -1;

    process["exit"](
      if (
        #if closure_advanced
          methodsRenamed && classesRenamed
        #else
          classesRenamed
        #end 
      ) 0 else 500
    );
  }
  
}