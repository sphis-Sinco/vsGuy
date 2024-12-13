package sinco.vsguy.substates;

import sinco.vsguy.substates.f3scene.components.*;

class F3Scene extends MusicBeatSubstate
{
	public var CURRENT_STATE:F3States = GAMEPLAY_STATE;

	public var leftText:FlxText;
	public var rightText:FlxText;

	override public function new()
	{
		super();
	}

	override public function create()
    {
        super.create();
    }

	override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}