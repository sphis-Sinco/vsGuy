package sinco.vsguy.popups;

import mikolka.compatibility.FunkinPath;

class Popup extends FlxAtlasSprite
{
	public var animToPlay:String;
	public var finishTimer:FlxTimer;
	public var animLength:Float = 1.0;

	public function new(x:Float, y:Float, path:String)
	{
		super(x, y, FunkinPath.animateAtlas('shopItems_popups/$path'));

		this.visible = false;
		this.animToPlay = path;

		this.scrollFactor.set(0, 0);

		this.animation.pause();

		finishTimer = new FlxTimer(new FlxTimerManager());
	}

	public function start()
	{
		this.visible = true;
		this.playAnimation('$animToPlay');
		finishTimer.start(animLength, function(timer:FlxTimer)
		{
			end();
		});
	}

	dynamic public function end()
	{
		this.destroy();
	}
}
