package sinco.vsguy.states.shop;

class Sinco extends FlxAtlasSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y, FunkinPath.animateAtlas('shop/Sinco_Assets'));

                animation.play('Sinco Idle');
	}
        
}