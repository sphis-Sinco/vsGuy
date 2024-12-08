package states;

import objects.Character;

class ShopState extends MusicBeatState
{
	public var sinco:Character;
	public var card:FlxSprite;

    public var itemName:FlxText;

	override public function new()
	{
		sinco = new Character(0, 0, 'shop-sinco');
		sinco.screenCenter();
		sinco.x -= 200;
		sinco.y += 180;

		card = new FlxSprite(0, 0).loadGraphic(Paths.image('shop/Item Card'));
		card.screenCenter();
        card.x += 380;

		itemName = new FlxText(0,0,0,"Item", 16);
		itemName.setFormat(Paths.font("comicsans.ttf"), 64, FlxColor.RED, LEFT);
		itemName.screenCenter();
		itemName.x += 160;
		itemName.y -= 320;

		super();
	}

	override public function create()
	{
		add(sinco);
		add(card);
        // FlxTween.color(card, 1, card.color, FlxColor.RED);

		add(itemName);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}