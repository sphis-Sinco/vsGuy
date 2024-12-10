package sinco.vsguy.states.new_title;

import mikolka.compatibility.FunkinPath;

class TitleBF extends FlxAtlasSprite
{
	public function new(x:Float, y:Float)
	{
        super(x, y, FunkinPath.animateAtlas('titlescreen/boyfriend'));
    }
}