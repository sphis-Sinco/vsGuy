package sinco.vsguy.states.credits;

import openfl.Assets;
import haxe.Json;
import sinco.vsguy.states.credits.json.*;

class CreditsMenu extends MusicBeatState
{
    public var credits:CreditsList = CreditManager.templateCredits();

	override public function new()
	{
		credits = Json.parse(Assets.getText(Paths.json('credits')));
        trace(credits.credits);

		super();
	}

	override public function create()
	{
		super.create();
	}

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
    
}