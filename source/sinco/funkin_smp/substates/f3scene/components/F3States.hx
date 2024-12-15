package sinco.funkin_smp.substates.f3scene.components;

enum abstract F3States(String) from String to String
{
	public var GAMEPLAY_STATE:String = 'gameplay';

	public var MENU_STATE:String = 'menu';
	public var MAINMENU_STATE:String = 'main-$MENU_STATE';
}
