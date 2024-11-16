package mikolka.vslice.charSelect.pslice;

import mikolka.compatibility.ModsHelper;

class ModSelector extends FlxTypedSpriteGroup<FlxSprite> {

    public var curMod(get,never):String;
    function get_curMod() {
        return directories[curDirectory] ?? '';
    }
    private var curDirectory = 0;
    private var directories:Array<String> = [null];
    private var parent:CharSelectSubState;

    public function new(parent:CharSelectSubState) {
        super();
        this.parent = parent;
        var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 42).makeGraphic(FlxG.width, 70, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		for (folder in ModsHelper.getModsWithPlayersRegistry())
		{
			directories.push(folder);
		}

		var found:Int = directories.indexOf(ModsHelper.getActiveMod());
		if (found > -1)
			curDirectory = found;
		changeDirectory();
    }
    
    public function changeDirectory(change:Int = 0)
        {
        }
}