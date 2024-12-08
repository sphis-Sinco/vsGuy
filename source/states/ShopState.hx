package states;

import haxe.Json;
import openfl.Assets;
import shaders.ColorShader;
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
					
					if (!ClientPrefs.BoughtStoreItems.contains(file))
						ClientPrefs.BoughtStoreItems.push(file);

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
			if (!ClientPrefs.BoughtStoreItems.contains(item))
				ClientPrefs.BoughtStoreItems.remove(item);
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
		xpText.text = 'XP: ${ClientPrefs.XP}';

		itemName = new FlxText(0, 0, 0, "Item - Price XP", 16);
		itemName.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.RED, LEFT);
		itemName.screenCenter();
		itemName.x += 280;
		itemName.y -= 340;

        itemDesc = new FlxText(0,0,0, "Description", 16);
		itemDesc.setFormat(itemName.font, Math.round(itemName.size / 2), itemName.color, itemName.alignment);
		itemDesc.setPosition(itemName.x + 20, itemName.y + 100);

		// items.push(ShopItemManager.blankShopItem());

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
		add(xpText);

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
				trace(currentSelection);
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
			itemDesc.text = currentItem.description;

			if (currentItem.sincoReact)
				if (currentItem.sincoInterested)
					sinco.playAnim('interested');
				else
					sinco.playAnim('uninterested');
		} else {
			itemName.text = 'No Shop Items';
			itemDesc.text = '';
		}
	}
}

class XPPopup extends FlxSpriteGroup
{
	// thank you open-source
	// taken (with modifs) from fnf vs impostor v4 source code

	var alphaTween:FlxTween;
	var bean:FlxSprite;
	var popupBG:FlxSprite;
	var theText:FlxText;
	var lerpScore:Float = 0;
	var canLerp:Bool = false;

	public function new(amount:Float, ?camera:FlxCamera = null)
	{
		super(x, y);
		this.y -= 100;
		lerpScore = amount;

		ClientPrefs.XP += amount;

		var colorShader:ColorShader = new ColorShader(0);

		ClientPrefs.saveSettings();
		popupBG = new FlxSprite(FlxG.width - 300, 0).makeGraphic(300, 100, 0xF8FF0000);
		popupBG.visible = false;
		popupBG.scrollFactor.set();
		add(popupBG);

		bean = new FlxSprite(0, 0).loadGraphic(Paths.image('shop/bean'));
		bean.setPosition(popupBG.getGraphicMidpoint().x - 90, popupBG.getGraphicMidpoint().y - (bean.height / 2));
		bean.antialiasing = true;
		bean.updateHitbox();
		bean.scrollFactor.set();
		// add(bean);

		theText = new FlxText(popupBG.x + 90, popupBG.y + 35, 200, Std.string(amount), 35);
		theText.setFormat(Paths.font("comicsans.ttf"), 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		theText.setPosition(popupBG.getGraphicMidpoint().x - 10, popupBG.getGraphicMidpoint().y - (theText.height / 2));
		theText.updateHitbox();
		theText.borderSize = 3;
		theText.scrollFactor.set();
		theText.antialiasing = true;
		add(theText);

		bean.shader = colorShader.shader;
		theText.shader = colorShader.shader;

		FlxTween.tween(this, {y: 0}, 0.35, {ease: FlxEase.circOut});

		new FlxTimer().start(0.9, function(tmr:FlxTimer)
		{
			canLerp = true;
			colorShader.amount = 1;
			FlxTween.tween(colorShader, {amount: 0}, 0.8, {ease: FlxEase.expoOut});
			FlxG.sound.play(Paths.sound('getbeans'), 0.9);
		});

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if (camera != null)
		{
			cam = [camera];
		}
		alpha = 0;
		bean.cameras = cam;
		theText.cameras = cam;
		popupBG.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {
			onComplete: function(twn:FlxTween)
			{
				alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
					startDelay: 2.5,
					onComplete: function(twn:FlxTween)
					{
						alphaTween = null;
						remove(this);
					}
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canLerp)
		{
			lerpScore = Math.floor(FlxMath.lerp(lerpScore, 0, CoolUtil.boundTo(elapsed * 4, 0, 1) / 1.5));
			if (Math.abs(0 - lerpScore) < 10)
				lerpScore = 0;
		}

		theText.text = Std.string(lerpScore);
		bean.setPosition(popupBG.getGraphicMidpoint().x - 90, popupBG.getGraphicMidpoint().y - (bean.height / 2));
		theText.setPosition(popupBG.getGraphicMidpoint().x - 10, popupBG.getGraphicMidpoint().y - (theText.height / 2));
	}

	override function destroy()
	{
		if (alphaTween != null)
		{
			alphaTween.cancel();
		}
		super.destroy();
	}
}