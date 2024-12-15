package sinco.funkin_smp.substates.f3scene;

import sinco.funkin_smp.substates.f3scene.components.*;

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

		leftText = new FlxText(10, 10, 0, "Left Text", 16);
		leftText.setFormat(Paths.font(GuyConsts.DEFAULT_FONT), 16, FlxColor.WHITE, LEFT);

		rightText = new FlxText(10, 10, 0, "Right Text", 16);
		rightText.setFormat(Paths.font(GuyConsts.DEFAULT_FONT), 16, FlxColor.WHITE, RIGHT);

		leftText.scrollFactor.set(0, 0);
		rightText.scrollFactor.set(0, 0);
	}

	override public function create()
	{
		super.create();

		add(leftText);
		add(rightText);

		f3check();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([ANY]))
			f3check();
	}

	public function f3check()
	{
		if (controls.justReleased('f3menu'))
		{
			ENABLED = !ENABLED;
			trace('F3 SCENE IS NOW ${ENABLED ? 'ENABLED' : 'DISABLED'}!');
		}

		leftText.visible = ENABLED;
		rightText.visible = leftText.visible;
		settexts(CURRENT_STATE);
	}

	public function settexts(state:F3States)
	{
		var songName:String = PlayState.SONG.song;

		switch (state)
		{
			case GAMEPLAY_STATE:
				leftText.text = 'Song: $songName';
				rightText.text = 'Right Text';

			default:
				leftText.text = 'Left Text';
				rightText.text = 'Right Text';
		}

		leftText.x = 10;
		rightText.x = FlxG.width - rightText.width - 10;
	}
}
