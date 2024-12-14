package options;

class GameSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('game_menu', 'Game Settings');
		rpcTitle = 'Game Settings Menu'; // for Discord Rich Presence

		var option:Option = new Option('Reset Save (READ DESC)', // Name
			'THIS WILL RESET YOUR ENTIRE SAVE' + "'S " + 'DATA.', // Description
			'resetSave', // Save data variable name
			BOOL); // Variable type
		if (!OptionsState.onPlayState)
			addOption(option);

		var option:Option = new Option('Color Chat', // Name
			'Instead of being White like in MC the Minecraft Chat Text will be the characters health bar colors', // Description
			'colorChat', // Save data variable name
			BOOL); // Variable type
		addOption(option);

		super();
	}
}
