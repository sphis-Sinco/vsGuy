package sinco.vsguy.states.credits;

import sinco.vsguy.states.credits.json.CreditsItem.CreditUser;
import sinco.vsguy.states.credits.json.CreditsList;
import openfl.Assets;
import haxe.Json;
import sinco.vsguy.states.credits.json.*;
import flixel.FlxG;

class CreditsMenu extends MusicBeatState
{
    public var creditsFile:CreditsList = CreditManager.templateCredits();
	public var credits:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

    public var textSpeed:Float = 5.0;

	var scrollPaused:Bool = false;

	var pausedText:FlxText;
	var howToPauseText:FlxText;

	override public function new()
	{
		creditsFile = Json.parse(Assets.getText(Paths.json('credits')));
        // trace(credits.credits);

        var index:Int = 0;

        var num:Int = 0;
		for (item in creditsFile.credits)
		{
			var userList:Array<CreditUser> = item.header.users;

            num++;
			for (user in userList)
			{
				num++;
			}
		}

		var yOffset:Float = FlxG.height + num * 30;
        for (item in creditsFile.credits)
        {
			var userList:Array<CreditUser> = item.header.users;

			var header:FlxText = new FlxText(10, yOffset, 0, item.header.text, 64);
			yOffset += 30;
			credits.add(header);

			var secondaryIndex:Int = 0;
            for (user in userList)
            {
				var newuser = '${user.person}${user.role.length > 0 ? ' - ${user.role}' : ''}';

				var person:FlxText = new FlxText(header.x, yOffset, 0, newuser, Math.round(header.size / 2));
				yOffset += 30;
				credits.add(person);

                trace(newuser);
				secondaryIndex++;
            }
			index++;
        }
        
		pausedText = new FlxText(-10, 10, FlxG.width, 'PAUSED');
		pausedText.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, FlxTextAlign.RIGHT);
		pausedText.scrollFactor.set(0, 0);
		pausedText.visible = false;

        /*
		var upDownText = new FlxText(-10, 670, FlxG.width, 'UP/DOWN to Navigate');
		upDownText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.RIGHT);
		upDownText.scrollFactor.set(0, 0);
		upDownText.alpha = 0.4;
		add(upDownText);
        */

		howToPauseText = new FlxText(-10, 695, FlxG.width, 'SPACE/ENTER to Pause');
		howToPauseText.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.RIGHT);
		howToPauseText.scrollFactor.set(0, 0);
		howToPauseText.alpha = 0.4;

		super();
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
			pausedText.visible = false;
            if (textSpeed == 0)
				FlxTween.tween(this, {textSpeed: 5}, 1.0);
            else {
				pausedText.visible = true;
				FlxTween.tween(this, {textSpeed: 0}, 1.0);
            }
        }

        for (text in credits)
        {
			text.y -= textSpeed;

            if (text.y < (0 - credits.length * 30))
                text.y = FlxG.height + credits.length * 30;
        }

        super.update(elapsed);
    }
    
}