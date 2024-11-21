package options;

class GameSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('game_menu', 'Game Settings');
		rpcTitle = 'Game Settings Menu'; //for Discord Rich Presence

		// todo

		var option:Option = new Option('Reset Save (READ DESCRIPTION)', //Name
			'THIS WILL RESET YOUR ENTIRE SAVE.', //Description
			'resetSave', //Save data variable name
			BOOL); //Variable type
		if (!OptionsState.onPlayState) addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;

	function onChangeVibration()
	{
		if(ClientPrefs.data.vibrating)
			lime.ui.Haptic.vibrate(0, 500);
	}
}