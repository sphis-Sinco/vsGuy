package sinco.vsguy.substates.f3scene;

import sinco.vsguy.substates.f3scene.components.*;

class F3Scene extends MusicBeatSubstate
{
	public var CURRENT_STATE:F3States = GAMEPLAY_STATE;
	public var ENABLED:Bool = false;

	public var leftText:FlxText;
	public var rightText:FlxText;

	override public function new(state:F3States, ?enabled:Bool = false)
	{
		super();

		this.ENABLED = enabled; // the new() param for enabled takes priority
		this.CURRENT_STATE = state; // the new() param for state takes priority
	}

	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function f3check()
	{
		if (FlxG.keys.justReleased.F3)
		{
			ENABLED = !ENABLED;
			trace('F3 SCENE IS NOW ${ENABLED ? 'ENABLED' : 'DISABLED'}!');
		}
	}
}
