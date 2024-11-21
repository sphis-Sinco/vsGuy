package options;

class GameSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('game_menu', 'Game Settings');
		rpcTitle = 'Game Settings Menu'; //for Discord Rich Presence

		// todo

		var option:Option = new Option('Reset Save (READ DESC)', //Name
			'THIS WILL RESET YOUR ENTIRE SAVE.', //Description
			'resetSave', //Save data variable name
			BOOL); //Variable type
		if (!OptionsState.onPlayState) addOption(option);

		super(); 
	}
}