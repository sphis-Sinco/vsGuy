package states;

import objects.Character;

class ShopState extends MusicBeatState
{
	public var sinco:Character;
	public var card:FlxSprite;

	override public function new()
	{
		sinco = new Character(0, 0, 'shop-sinco');
		sinco.screenCenter();
		sinco.x -= 200;
		sinco.y += 180;

		card = new FlxSprite(0, 0).loadGraphic(Paths.image('shop/Item Card'));
		card.screenCenter();
        card.x += 380;

		super();
	}

	override public function create()
	{
		add(sinco);
		add(card);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}