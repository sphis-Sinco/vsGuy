package sinco.vsguy.states.new_title;

import mikolka.compatibility.FunkinPath;

class TitleBF extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('titlescreen/bf');

		animation.addByPrefix('idle', 'boyfriend idle dance', 24);
		animation.addByPrefix('hey', 'boyfriend hey', 24, false);
	}
}
