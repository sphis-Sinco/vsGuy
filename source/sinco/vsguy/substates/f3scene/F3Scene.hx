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

		leftText = new FlxText(0,0, FlxG.width, "Left Text", 16);
		leftText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);

		rightText = new FlxText(0, 0, FlxG.width, "Right Text", 16);
		rightText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
	}

	override public function create()
	{
		super.create();

		add(leftText);
		add(rightText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (leftText.visible != ENABLED && rightText.visible != ENABLED) {
			leftText.visible = ENABLED;
			rightText.visible = ENABLED;
		}
	}

	public function f3check()
	{
		if (controls.justReleased('f3menu'))
		{
			ENABLED = !ENABLED;
			trace('F3 SCENE IS NOW ${ENABLED ? 'ENABLED' : 'DISABLED'}! KEY PRESSED: ${ClientPrefs.keyBinds.get('f3menu')}');
		}
	}
}
