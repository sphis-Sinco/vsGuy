package sinco.vsguy.states.shop;

import sinco.vsguy.popups.DoubleXP;
import haxe.Json;
import openfl.Assets;
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

	public var xpText:FlxText;

	public var itemName:FlxText;
	public var itemDesc:FlxText;

	public var doubleXp:DoubleXP;

	override public function new()
	{
		currentItem = ShopItemManager.blankShopItem();

		#if sys
		var tempList:Array<String> = FileSystem.readDirectory('assets/shared/shop/');
		#if MODS_ALLOWED
		var backup:Array<String> = tempList;
		tempList = CoolUtil.loadFileList('assets/shared/shop/', null, ['.json']);
		if (tempList.length < 1)
			tempList = backup;
		#end
		#else
		var tempList:Array<String> = [];
		#end

		trace('tempList: $tempList');
		
		var itemsList:Array<String> = [];
		for (file in tempList)
		{
			if (file.endsWith('.json')) {
				try {
					items.push(Json.parse(Assets.getText(Paths.getFolderPath('$file', 'shared/shop'))));
					
					if (!ClientPrefs.data.BoughtStoreItems.contains(file))
						ClientPrefs.data.BoughtStoreItems.push(file);

					itemsList.push(items[items.length - 1].name);
				} catch(e){
					trace(e);
				}
			}
		}
		trace('items: $itemsList');

		// remove unused ones
		for (item in tempList)
		{
			if (!ClientPrefs.data.BoughtStoreItems.contains(item))
				ClientPrefs.data.BoughtStoreItems.remove(item);
		}

		sinco = new Character(0, 0, 'shop-sinco');
		sinco.screenCenter();
		sinco.x -= 200;
		sinco.y += 180;
		sinco.animation.finishCallback = sincoFinishAnim;

		card = new FlxSprite(0, 0).loadGraphic(Paths.image('shop/Item Card'));
		card.screenCenter();
		card.x += 350;

		xpText = new FlxText(0,0,0,"XP", 16);
		xpText.setFormat(Paths.font("comicsans.ttf"), 64, FlxColor.RED, LEFT);
		xpText.setPosition(10, 10);
		xpText.text = 'XP: ${ClientPrefs.data.XP}';

		itemName = new FlxText(0, 0, 0, "Item - Price XP", 16);
		itemName.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.BLACK, LEFT);
		itemName.screenCenter();
		itemName.x += 280;
		itemName.y -= 340;

        itemDesc = new FlxText(0,0,0, "Description", 16);
		itemDesc.setFormat(itemName.font, Math.round(itemName.size / 2), itemName.color, itemName.alignment);
		itemDesc.setPosition(itemName.x + 20, itemName.y + 100);

		// items.push(ShopItemManager.blankShopItem());

		updateItem();

		doubleXp = new DoubleXP(0,0);

		super('Shop');
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
		add(xpText);

		add(doubleXp);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		var previousSel:Int = currentSelection;
		if (controls.UI_LEFT_R)
		{
			currentSelection -= 1;
			if (currentSelection < 0)
				currentSelection = 0;

			if (currentSelection != previousSel) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				updateItem();
				trace(currentSelection);
			}
		}
		if (controls.UI_RIGHT_R)
		{
			currentSelection += 1;
			if (currentSelection > items.length - 1)
				currentSelection = items.length - 1;
			
			if (currentSelection != previousSel) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				updateItem();
				trace(currentSelection);
			}
		}
		if (controls.ACCEPT)
		{
			if (!ClientPrefs.data.BoughtStoreItems.contains(currentItem.name) && ClientPrefs.data.XP >= currentItem.price)
			{
				trace('New Item bought: ${currentItem.name}');
				ClientPrefs.data.BoughtStoreItems.push(currentItem.name);
				ClientPrefs.data.EnabledStoreItems.push(currentItem.name);
				ClientPrefs.data.XP -= currentItem.price;
				updateItem();
				xpText.text = 'XP: ${ClientPrefs.data.XP}';
			}
		}

		super.update(elapsed);
	}

	public function updateItem()
	{
		if (items.length > 0) {
			currentItem = items[currentSelection];

			if (currentItem == null)
				currentItem = ShopItemManager.blankShopItem();

			itemName.text = '${currentItem.name} - ${currentItem.price > 0.0 ? '${currentItem.price} XP' : 'Free'}';
			itemDesc.text = '';

			if (ClientPrefs.data.BoughtStoreItems.contains(currentItem.name))
				itemDesc.text += 'BOUGHT\n';

			itemDesc.text += currentItem.description;

			if (!ClientPrefs.data.BoughtStoreItems.contains(currentItem.name))
				if (currentItem.sincoReact)
					if (currentItem.sincoInterested)
						sinco.playAnim('interested');
					else
						sinco.playAnim('uninterested');
		} else {
			itemName.text = 'No Shop Items';
			itemDesc.text = '';
			sinco.playAnim('uninterested');
		}
	}
}