package states;

import objects.Character;
import sinco.vsguy.data.ShopItem.ShopItem;
import sinco.vsguy.data.ShopItem.ShopItemManager;

class ShopState extends MusicBeatState
{
	public var sinco:Character;
	public var card:FlxSprite;

	public var items:Array<ShopItem> = [];

	public var currentItem:ShopItem;
	public var currentSelection:Int = 0;

	public var itemName:FlxText;
	public var itemDesc:FlxText;

	override public function new()
	{
		currentItem = ShopItemManager.blankShopItem();

		sinco = new Character(0, 0, 'shop-sinco');
		sinco.screenCenter();
		sinco.x -= 200;
		sinco.y += 180;
		sinco.animation.finishCallback = sincoFinishAnim;

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

		items.push(ShopItemManager.blankShopItem());

		updateItem();

		super();
	}

	public function sincoFinishAnim(name:String)
	{
		if (sinco.animation.name != 'idle')
			sinco.playAnim('idle');
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
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	public function updateItem()
	{
		currentItem = items[currentSelection];

		if (currentItem == null)
			currentItem = ShopItemManager.blankShopItem();

		itemName.text = '${currentItem.name} - ${currentItem.price > 0.0 ? "$"+currentItem.price : 'Free'}';
		itemDesc.text = currentItem.description;

		if (currentItem.sincoReact)
			if (currentItem.sincoInterested)
				sinco.playAnim('interested');
			else
				sinco.playAnim('uninterested');
	}
}