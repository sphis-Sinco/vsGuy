package sinco.vsguy.caching;

class Menus
{
    public static function cacheImages(?menu:String) {
		Paths.image('menuBG');
		Paths.image('menuBGBlue');
		Paths.image('menuBGMagenta');
		Paths.image('menuDesat');
        
        switch(menu) {
            case 'mainmenu':
				var mainmenuFolder:Array<String> = Paths.readDirectory('mainmenu');

                for (file in mainmenuFolder)
                {
                    Paths.image('mainmenu/$file');
                }

            case 'mod':
                Paths.image('modsMenuButtons');
        }
    }
}