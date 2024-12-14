package sinco.vsguy.states.credits;

import sinco.vsguy.bases.MenuState;
import sinco.vsguy.states.credits.json.CreditsItem.CreditUser;
import sinco.vsguy.states.credits.json.CreditsList;
import openfl.Assets;
import haxe.Json;
import sinco.vsguy.states.credits.json.*;
import flixel.FlxG;

class CreditsMenu extends MenuState
{
	public var creditsFile:CreditsList = CreditManager.templateCredits();
	public var credits:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	public var textSpeed:Float = 0.0;

	var pausedText:FlxText;
	var howToPauseText:FlxText;

	override public function new()
	{
		creditsFile = Json.parse(Assets.getText(Paths.json('credits')));
		// trace(credits.credits);

		var index:Int = 0;

		var yOffset:Float = 10;
		for (item in creditsFile.credits)
		{
			var headerTxt:String = 'Undefined Header';

			if (item.header.text != null)
				headerTxt = item.header.text;
			else
				headerTxt = item.text;

			var header:FlxText = new FlxText(10, yOffset, FlxG.width, headerTxt, 48);
			yOffset += 60;

			var limit1:String = 'Production and Business Development Partner';
			if (headerTxt.length > limit1.length)
				yOffset += 60;

			credits.add(header);

			var secondaryIndex:Int = 0;
			var userList:Array<CreditUser> = item.header.users;
			// trace(headerTxt);
			if (userList != null)
			{
				for (user in userList)
				{
					var newrole:Null<String> = null;

					try
					{
						newrole = '${user.role.length > 0 ? ' - ${user.role}' : ''}';
					}
					catch (e)
					{
						newrole = '';
					}

					var newuser = '${user.person}${newrole != null ? newrole : ''}';

					var person:FlxText = new FlxText(header.x, yOffset, FlxG.width, newuser, Math.round(header.size / 2));
					yOffset += 45;

					if (newuser.length > limit1.length * 2)
						yOffset += 45;

					credits.add(person);

					// trace(newuser);
					secondaryIndex++;
				}
			}
			index++;
		}

		pausedText = new FlxText(-10, 10, FlxG.width, 'PAUSED');
		pausedText.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, FlxTextAlign.RIGHT);
		pausedText.scrollFactor.set(0, 0);

		/*
			var upDownText = new FlxText(-10, 670, FlxG.width, 'UP/DOWN to Navigate');
			upDownText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.RIGHT);
			upDownText.scrollFactor.set(0, 0);
			upDownText.alpha = 0.4;
			add(upDownText);
		 */

		howToPauseText = new FlxText(-10, 695, FlxG.width, '${ClientPrefs.keyBinds.get('accept')[0]}/${ClientPrefs.keyBinds.get('accept')[1]} to Pause');
		howToPauseText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.RIGHT);
		howToPauseText.scrollFactor.set(0, 0);
		howToPauseText.alpha = 0.4;

		super('credits');
	}

	override public function create()
	{
		add(credits);
		add(pausedText);
		add(howToPauseText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (controls.BACK)
			MusicBeatState.switchState(new MainMenuState());

		if (controls.ACCEPT)
		{
			FlxTween.cancelTweensOf(this);
			pausedText.visible = !pausedText.visible;
			if (!pausedText.visible)
				FlxTween.tween(this, {textSpeed: 5}, 1.0);
			else
				FlxTween.tween(this, {textSpeed: 0}, 1.0);
		}

		for (text in credits)
		{
			text.y -= textSpeed;

			if (text.y < (0 - credits.length * 30))
				text.y = FlxG.height + credits.length * 21;
		}

		super.update(elapsed);
	}
}
