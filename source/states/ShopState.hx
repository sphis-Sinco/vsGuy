package states;

import objects.Character;

class ShopState extends MusicBeatState
{
    public var sinco:Character;

	override public function new()
	{
		sinco = new Character(0, 0, 'shop-sinco');
        sinco.screenCenter();
		sinco.y += 400;

		super();
	}

	override public function create()
	{
		add(sinco);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}