package mikolka.funkin.custom;

import mikolka.compatibility.FunkinPath;
import haxe.Json;

class PsliceRegistry {
    final regPath:String;
    public function new(registryName:String) {
        regPath = 'registry/$registryName';
    }
    function readJson(id:String):Dynamic {
        var char_path = FunkinPath.getPath('$regPath/$id.json');

        if(!FileSystem.exists(char_path)) return null;

        var text = File.getContent(char_path);
        var results = Json.parse(text);

        #if MODS_ALLOWED
        if (results == null)
        {
            char_path = Paths.modsJson('$regPath/$id');
            trace(char_path);
            if(!FileSystem.exists(char_path)) return null;

            text = File.getContent(char_path);
            results = Json.parse(text);
        }
        #end

        return results;// new PlayerData();
    }
    function listJsons():Array<String> {
        var char_path = FunkinPath.getPath(regPath);
        var basedCharFiles = FileSystem.readDirectory(char_path);
        if(char_path == 'dlcs/$regPath'){
            var nativeChars = FileSystem.readDirectory(FunkinPath.getPath(regPath,true));
            basedCharFiles = basedCharFiles.concat(nativeChars);
        }
        return basedCharFiles.filter(s -> s.endsWith(".json")).map(s -> s.substr(0,s.length-5));
    }
}