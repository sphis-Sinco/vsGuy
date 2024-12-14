package sinco.vsguy.popups;

import shaders.ColorShader;

class XPPopup extends FlxSpriteGroup
{
	// thank you open-source
	// taken (with modifs) from fnf vs impostor v4 source code
	var alphaTween:FlxTween;
	var textTween:FlxTween;
	var textTween2:FlxTween;
	var txtTweenStarted:Bool = false;
	var txtTweenStarted2:Bool = false;
	var bean:FlxSprite;
	var popupBG:FlxSprite;
	var theText:FlxText;
	var theTextAdditional:FlxText;
	var lerpScore:Float = 0;
	var lerpScoreAdd:Float = 0;
	var canLerp:Bool = false;

	public function new(amount:Float, additional:Float = 0, ?camera:FlxCamera = null)
	{
		super(x, y);
		this.y -= 100;
		lerpScore = amount;
		lerpScoreAdd = additional;

		ClientPrefs.data.XP += (amount + additional);

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

		theText = new FlxText(popupBG.x + 90, popupBG.y + 35, 200, Std.string(FlxStringUtil.formatMoney(amount, false, true)), 35);
		theText.setFormat(Paths.font("comicsans.ttf"), 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		theText.setPosition(popupBG.getGraphicMidpoint().x - 10, popupBG.getGraphicMidpoint().y - (theText.height / 2));
		theText.updateHitbox();
		theText.borderSize = 3;
		theText.scrollFactor.set();
		theText.antialiasing = true;
		add(theText);

		theTextAdditional = new FlxText(theText.x, theText.y + 35, 200, Std.string(FlxStringUtil.formatMoney(additional, false, true)), 35);
		theTextAdditional.setFormat(theText.font, theText.size, FlxColor.GREEN, theText.alignment, theText.borderStyle, theText.borderColor);
		theTextAdditional.updateHitbox();
		theTextAdditional.borderSize = theText.borderSize;
		theTextAdditional.scrollFactor.set();
		theTextAdditional.antialiasing = theText.antialiasing;
		theTextAdditional.visible = additional > 0;
		add(theTextAdditional);

		bean.shader = colorShader.shader;
		theText.shader = colorShader.shader;
		theTextAdditional.shader = colorShader.shader;

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
		theTextAdditional.cameras = cam;
		popupBG.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {
			onComplete: function(twn:FlxTween)
			{
				alphaTween = FlxTween.tween(this, {alpha: 0}, 1.0, {
					startDelay: 3,
					onComplete: function(twn:FlxTween)
					{
						alphaTween = null;
						remove(this);
					}
				});
			}
		});
		textTween = FlxTween.tween(theTextAdditional, {alpha: 0, y: -100}, 1.0, {
			startDelay: 2.0,
			onComplete: function(twn:FlxTween)
			{
				// idk
			},
			onStart: function(twn:FlxTween)
			{
				txtTweenStarted = true;
			}
		});
		textTween2 = FlxTween.tween(theText, {alpha: 0, y: -100}, 1.0, {
			startDelay: 1.0,
			onComplete: function(twn:FlxTween)
			{
				// idk
			},
			onStart: function(twn:FlxTween)
			{
				txtTweenStarted2 = true;
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canLerp)
		{
			lerpScore = Math.floor(FlxMath.lerp(lerpScore, 0, CoolUtil.boundTo(elapsed * 4, 0, 1) / 1.5));
			lerpScoreAdd = Math.floor(FlxMath.lerp(lerpScoreAdd, 0, CoolUtil.boundTo(elapsed * 4, 0, 1) / 1.5));
			if (Math.abs(0 - lerpScore) < 10)
				lerpScore = 0;
			if (Math.abs(0 - lerpScoreAdd) < 10)
				lerpScoreAdd = 0;
		}

		theText.text = Std.string(lerpScore);
		theTextAdditional.text = Std.string(lerpScoreAdd);
		bean.setPosition(popupBG.getGraphicMidpoint().x - 90, popupBG.getGraphicMidpoint().y - (bean.height / 2));

		if (!txtTweenStarted2)
			theText.setPosition(popupBG.getGraphicMidpoint().x - 10, popupBG.getGraphicMidpoint().y - (theText.height / 2));
		if (!txtTweenStarted)
			theTextAdditional.setPosition(theText.x, theText.y + ((theTextAdditional.height / 2) * 2));
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
