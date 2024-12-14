package sinco.vsguy.bases;

import sinco.vsguy.systems.Cache.Menus;

class MenuState extends MusicBeatState
{
	override public function new(?menu:String = 'blank', ?windowsuffix:Null<String> = null)
	{
		super(windowsuffix);

		Menus.cacheImages(menu);
		Menus.cacheSounds(menu);
	}

	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
