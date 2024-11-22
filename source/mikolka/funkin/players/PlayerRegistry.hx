package mikolka.funkin.players;

import haxe.Json;
import mikolka.funkin.players.PlayerData;
import mikolka.compatibility.FunkinPath;

using mikolka.funkin.custom.FunkinTools;
using StringTools;
//TODO softcode this soon
class PlayerRegistry extends PsliceRegistry{
    public static var instance:PlayerRegistry = new PlayerRegistry();

    var chars:Array<String> = ClientPrefs.data.unlockedCharacters;
    var files:Array<String> = [];

    public function new() {
        super('players');
    }

    public function isCharacterOwned(id:String):Bool {
        return true;
    }
    public function hasNewCharacter():Bool {
        var newchar:Bool = false;
        chars = ClientPrefs.data.unlockedCharacters;

        try { 
            files = FileSystem.readDirectory(Paths.mergeWithJson('registry/players'));
            for (file in FileSystem.readDirectory(Paths.modsRegistry('players/')))
            {
                files.push(file);
            }
            trace(files);
        } catch(e){
            files = ['bf'];
        }
        // trace('Savedata Players Registery$chars');
        // trace('Freeplay Players Registery: $files');

        newchar = chars != files;

        if (newchar){
            var newEntry:Bool = false;
            var newEntryAm:Int = 0;
            var newEntrys:Array<String> = [];

            for (i in 0...chars.length) {
                if (!files.contains(chars[i]))
                {
                    newEntrys.push(chars[i].split('.json')[0]);
                    chars.remove(chars[i]);
                    newEntryAm++;
                }
            }

            if (newEntryAm > 0) {
                trace('Removed $newEntryAm old Player Registries from Save data');
                trace(newEntrys);
            }

            newEntryAm = 0;
            newEntrys = [];

            for (i in 0...files.length) {
                if (!chars.contains(files[i]))
                {
                    newEntry = true;
                    newEntryAm++;
                    newEntrys.push(files[i].split('.json')[0]);
                }
            }

            if (!newEntry && newEntryAm == 0) return false;

            ClientPrefs.data.unlockedCharacters = files; // TODO: make this based off of the unlocked key in the JSON
            chars = ClientPrefs.data.unlockedCharacters;
            trace('$newEntryAm new Player Registeries');
            trace(newEntrys);
            return true;
        }
        
        return false;
    }
    public function fetchEntry(playableCharId:String):Null<PlayableCharacter> {
        try {
            var player_blob:Dynamic = readJson(playableCharId);// new PlayerData();
            if(player_blob == null) return null;
            var player_data = new PlayerData().mergeWithJson(player_blob,["freeplayDJ"]);
            var dj = new PlayerFreeplayDJData().mergeWithJson(player_blob.freeplayDJ);
            player_data.freeplayDJ = dj;
            return new PlayableCharacter(player_data);
        }
        catch(x){
            trace('Couldn\'t pull $playableCharId: ${x.message}');
            return null;
        }
        
    }
    
    // return ALL characters avaliable (from current mod)
    public function listEntryIds():Array<String> {
        return listJsons();
    }
    // This is only used to check if we should allow the player to open charSelect
    public function countUnlockedCharacters():Int {
        chars = ClientPrefs.data.unlockedCharacters;
        return chars.length;
    }
}