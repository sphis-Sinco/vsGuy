package states;

import objects.MenuBG;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;

	override function create()
	{
		super.create();

		var bg:MenuBG = new MenuBG('menuDesat');
		bg.scale.set(1,1);
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0x5c6579;
		add(bg);

		var guh:String;

		var homie:String = (controls.mobileC) ? 'kiddo' : 'bro';
		var esc:String = (controls.mobileC) ? 'B' : 'ESCAPE';

		guh = "Sup "
			+ homie
			+ ", looks like you're running an   \n
		outdated version of vs Guy plus! ("
			+ MainMenuState.modVer
			+ "),\n
		please update to "
			+ TitleState.updateVersion
			+ "!\n
		Press "
			+ esc
			+ " to proceed anyway.\n
		\n
		Thank you for playing the Mod!";

		warnText = new FlxText(0, 0, FlxG.width, guh, 32);
		warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		#if TOUCH_CONTROLS_ALLOWED
		addTouchPad('NONE', 'A_B');
		#end
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			if (controls.ACCEPT)
			{
				leftState = true;
				CoolUtil.browserLoad("https://github.com/sphis-Sinco/vsGuyPlus/releases");
			}
			else if (controls.BACK)
			{
				leftState = true;
			}

			if (leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function(twn:FlxTween)
					{
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
