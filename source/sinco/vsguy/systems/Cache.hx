package sinco.vsguy.systems;

class Cacher
{
	public static function cacheImg(image:String)
	{
		var cached:Bool = true;

		try
		{
			Paths.image(image);
			Paths.modsImages(image);
		}
		catch (e)
		{
			trace('Error with caching image("$image"): $e');
			cached = false;
		}

		if (cached)
			trace('cached image("$image")');
	}

	public static function cacheSound(sound:String)
	{
		var cached:Bool = true;

		try
		{
			Paths.sound(sound);
			Paths.modsSounds(sound, '');
		}
		catch (e)
		{
			trace('Error with caching sound("$sound"): $e');
			cached = false;
		}

		if (cached)
			trace('cached sound("$sound")');
	}
}

class Menus
{
	public static function cacheImages(?menu:String = '')
	{
		trace('CACHING MENU IMAGES');

		Cacher.cacheImg('alphabet');
		Cacher.cacheImg('menuBG');
		Cacher.cacheImg('menuBGBlue');
		Cacher.cacheImg('menuBGMagenta');
		Cacher.cacheImg('menuDesat');

		switch (menu.toLowerCase().replace(' ', '-'))
		{
			case 'mod':
				Cacher.cacheImg('modsMenuButtons');

			default:
				trace('"$menu" does not have a special caching case');
		}
	}

	public static function cacheSounds(?menu:String = '')
	{
		trace('CACHING MENU SOUNDS');

		Cacher.cacheSound('cancelMenu');
		Cacher.cacheSound('confirmMenu');
		Cacher.cacheSound('scrollMenu');

		switch (menu.toLowerCase().replace(' ', '-'))
		{
			case 'freeplay' | 'free-play' | 'fp':
				Cacher.cacheSound('channel_switch');
				Cacher.cacheSound('fav');
				Cacher.cacheSound('perfect');
				Cacher.cacheSound('remote_click');
				Cacher.cacheSound('static loop');
				Cacher.cacheSound('tv_on');
				Cacher.cacheSound('unfav');

			case 'char-sel' | 'charsel' | 'cs':
				Cacher.cacheSound('CS_confirm');
				Cacher.cacheSound('CS_hihat');
				Cacher.cacheSound('CS_Lights');
				Cacher.cacheSound('CS_locked');
				Cacher.cacheSound('CS_select');
				Cacher.cacheSound('CS_unlock');

			default:
				trace('"$menu" does not have a special caching case');
		}
	}
}
