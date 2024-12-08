package states;

import objects.Character;

class ShopState extends MusicBeatState
{
	public var sinco:Character;
	public var card:FlxSprite;

	public var itemName:FlxText;
	public var itemDesc:FlxText;

	override public function new()
	{
		sinco = new Character(0, 0, 'shop-sinco');
		sinco.screenCenter();
		sinco.x -= 200;
		sinco.y += 180;

		card = new FlxSprite(0, 0).loadGraphic(Paths.image('shop/Item Card'));
		card.screenCenter();
		card.x += 380;

		itemName = new FlxText(0, 0, 0, "Item - $Price", 16);
		itemName.setFormat(Paths.font("comicsans.ttf"), 64, FlxColor.RED, LEFT);
		itemName.screenCenter();
		itemName.x += 280;
		itemName.y -= 300;

        itemDesc = new FlxText(0,0,0, "Description", 16);
        itemDesc.setFormat(Paths.font("comicsans.ttf"), 32, itemName.color, itemName.alignment);
		itemDesc.setPosition(itemName.x + 20, itemName.y + 100);

		super();
	}

	override public function create()
	{
		add(sinco);
		add(card);
        // FlxTween.color(card, 1, card.color, FlxColor.RED);

		add(itemName);
		add(itemDesc);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}