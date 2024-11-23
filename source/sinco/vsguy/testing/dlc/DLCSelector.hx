package sinco.vsguy.testing.dlc;

import sinco.vsguy.modding.DLC;

class DLCSelector extends MusicBeatState
{
	override public function create()
	{
		trace('Old Mod System: '+Mods.parseList().all);

		trace('New DLC System: ' + DLC.dlcs);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("DLC Testing", null);
		#end

		var title:FlxText = new FlxText();
		title.text = "Dlc Testing State";
		title.size = 32;
		title.screenCenter(X);
		add(title);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
