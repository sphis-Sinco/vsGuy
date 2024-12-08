package sinco.vsguy.states.credits;

import sinco.vsguy.states.credits.json.CreditsItem.CreditUser;
import sinco.vsguy.states.credits.json.CreditsList;
import openfl.Assets;
import haxe.Json;
import sinco.vsguy.states.credits.json.*;

class CreditsMenu extends MusicBeatState
{
    public var creditsFile:CreditsList = CreditManager.templateCredits();
	public var credits:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	override public function new()
	{
		creditsFile = Json.parse(Assets.getText(Paths.json('credits')));
        // trace(credits.credits);

        var index:Int = 0;
        var yOffset:Float = 10.0;
        for (item in creditsFile.credits)
        {
			var userList:Array<CreditUser> = item.header.users;

			var header:FlxText = new FlxText(10, yOffset, 0, item.header.text, 16);
			yOffset += 30;
			credits.add(header);

			var secondaryIndex:Int = 0;
            for (user in userList)
            {
				var newuser = '${user.person}${user.role.length > 0 ? ' - ${user.role}' : ''}';

				var person:FlxText = new FlxText(header.x, yOffset, 0, newuser, header.size);
				yOffset += 30;
				credits.add(person);

                trace(newuser);
				secondaryIndex++;
            }
			index++;
        }

		super();
	}

	override public function create()
	{
		add(credits);

		super.create();
	}

    override public function update(elapsed:Float)
    {
        if (controls.BACK)
            MusicBeatState.switchState(new MainMenuState());

        super.update(elapsed);
    }
    
}