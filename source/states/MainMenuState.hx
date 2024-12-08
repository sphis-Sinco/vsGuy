package states;

import objects.MenuBG;
import mikolka.compatibility.ModsHelper;
import mikolka.vslice.freeplay.FreeplayState;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.0'; // This is also used for Discord RPC
	public static var pSliceVersion:String = '2.1'; 
	public static var modVer:String = '1.0'; 
	public static var funkinVersion:String = '0.5.1'; // Version of funkin' we are emulating
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		
	];

	var magenta:MenuBG;
	var camFollow:FlxObject;

	public function new(isDisplayingRank:Bool = false) {

		//TODO
		super();
	}

	public static function modVerInit()
	{
		modVer = Application.current.meta.get('version');
	}

	override function create()
	{
		Paths.clearUnusedMemory();
		ModsHelper.clearStoredWithoutStickers();
		
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		/**
			'story_mode',
			'freeplay',
			#if debug #if MODS_ALLOWED 'dlcs', #end #end
			'credits',
			#if !switch 'donate', #end
			'options'
		 */

		optionShit.push('story_mode');
		optionShit.push('freeplay');
		#if MODS_ALLOWED
		// manually put in the menuShit for this
		var list = Mods.parseList();
		if (list.all.length > 0)
			optionShit.push('dlcs');
		#end
		#if ACHIEVEMENTS_ALLOWED
		optionShit.push('awards');
		#end
		optionShit.push('credits');
		optionShit.push('options');
		optionShit.push('shop');


		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:MenuBG = new MenuBG('menuBG', yScroll);
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new MenuBG('menuBGMagenta', yScroll);
		magenta.visible = false;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.scale.set(1,1);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.updateHitbox();
			menuItem.screenCenter(X);
			if (optionShit[i] == 'dlcs')
				offset += 10*7;
		}

		var modVer:FlxText = new FlxText(0, FlxG.height - 18, FlxG.width, 'vs Guy Plus ${modVer + #if debug '-indev' #else '' #end} (P-slice ${pSliceVersion})', 12);
		modVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		modVer.scrollFactor.set();
		add(modVer);
		//var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' ", 12);
	
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		#if TOUCH_CONTROLS_ALLOWED
		addTouchPad('LEFT_FULL', 'A_B_E');
		#end

		super.create();

		FlxG.camera.follow(camFollow, null, 0.06);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			//if (FreeplayState.vocals != null)
				//FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.RESET)
				FlxG.resetState();

			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://www.makeship.com/shop/creator/friday-night-funkin');
				}
				else
				{
					selectedSomethin = true;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':{
								persistentDraw = true;
								persistentUpdate = false;
								// Freeplay has its own custom transition
								FlxTransitionableState.skipNextTransIn = true;
								FlxTransitionableState.skipNextTransOut = true;

								openSubState(new FreeplayState());
								subStateOpened.addOnce(state -> {
									for (i in 0...menuItems.members.length) {
										menuItems.members[i].revive();
										menuItems.members[i].alpha = 1;
										menuItems.members[i].visible = true;
										selectedSomethin = false;
									}
									changeItem(0);
								});
								
							}

							#if MODS_ALLOWED
							case 'dlcs':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end

							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}

							case 'shop':
								MusicBeatState.switchState(new ShopState());
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}
			if (#if TOUCH_CONTROLS_ALLOWED touchPad.buttonE.justPressed || #end controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();
		menuItems.members[curSelected].screenCenter(X);

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].centerOffsets();
		menuItems.members[curSelected].screenCenter(X);

		camFollow.setPosition(menuItems.members[curSelected].getGraphicMidpoint().x,
			menuItems.members[curSelected].getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0));
	}
}
