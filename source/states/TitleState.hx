package states;

import states.editors.ChartingState;
import sinco.vsguy.states.shop.ShopState;
import backend.WeekData;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.util.FlxDirectionFlags;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import shaders.ColorSwap;
import states.StoryMenuState;
import states.OutdatedState;
import states.MainMenuState;
import mikolka.vslice.components.ScreenshotPlugin;
import mikolka.vslice.AttractState;

using StringTools;

typedef TitleData =
{
	var titlex:Float;
	var titley:Float;
	var startx:Float;
	var starty:Float;
	var gfx:Float;
	var gfy:Float;
	var backgroundSprite:String;
	var bpm:Float;
	
	@:optional var animation:String;
	@:optional var dance_left:Array<Int>;
	@:optional var dance_right:Array<Int>;
	@:optional var idle:Bool;
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var enterTimer:FlxTimer;

	var credGroup:FlxGroup = new FlxGroup();
	var textGroup:FlxGroup = new FlxGroup();
	var blackScreen:FlxSprite;
	var credTextShit:Alphabet;
	var ngSpr:FlxSprite;

	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var mustUpdate:Bool = false;

	var bf:TitleBF;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		if (ClientPrefs.data.resetSave)
			ClientPrefs.resetSave();

		Paths.clearStoredMemory();
		super.create();
		Paths.clearUnusedMemory();

		if(!initialized)
		{
			ClientPrefs.loadPrefs();
			Language.reloadPhrases();
		}

		curWacky = FlxG.random.getObject(getIntroTextShit());

		#if CHECK_FOR_UPDATES
		if (ClientPrefs.data.checkForUpdates && !closedState)
		{
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/sphis-Sinco/vsGuyPlus/refs/heads/master/gitVersion.txt");

			http.onData = function(data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.modVer.trim();
				var ogcurVersion:String = curVersion;
				var ogupdateVersion:String = updateVersion;
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);

				if (curVersion.contains('-'))
				{
					if (updateVersion.contains('-')) {
						updateVersion = updateVersion.split('-')[1];
						curVersion = curVersion.split('-')[1];
					} else {
						curVersion = curVersion.split('-')[0];
					}
				}

				if (Std.parseFloat(updateVersion) > Std.parseFloat(curVersion))
				{
					trace('$ogupdateVersion > $ogcurVersion');
					mustUpdate = true;
				}
				else
				{
					trace('$ogupdateVersion ${ogupdateVersion == ogcurVersion ? '=' : '<'} $ogcurVersion');
				}
			}

			http.onError = function(error)
			{
				trace('error: $error');
			}

			http.request();

			#if OUTDATED
			mustUpdate = true;
			#end
		}
		#end

		if(!initialized)
		{
			if (FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				// trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
			#if TOUCH_CONTROLS_ALLOWED
			MobileData.init();
			#end
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if CHARTING
		MusicBeatState.switchState(new ChartingState());
		#elseif SHOP
		MusicBeatState.switchState(new ShopState());
		#else
		if (FlxG.save.data.flashing == null && !FlashingState.leftState)
		{
			controls.isInSubstate = false;
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		else
		{
			if (initialized)
				startIntro();
			else
			{
				//* FIRST INIT! iNITIALISE IMPORTED PLUGINS
				ScreenshotPlugin.initialize();
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		persistentUpdate = true;
		if (!initialized && FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('FlexRack'), 0);

		Conductor.bpm = musicBPM;

		logoBl = new FlxSprite(0,0);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin-guy');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;

		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.screenCenter(X);
		logoBl.updateHitbox();
		logoBl.screenCenter();
		logoBl.x += 400;
		
		if(ClientPrefs.data.shaders)
		{
			swagShader = new ColorSwap();
			logoBl.shader = swagShader.shader;
		}

		blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		blackScreen.scale.set(FlxG.width, FlxG.height);
		blackScreen.updateHitbox();
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52);

		if (FlxG.random.bool(1))
		{
			ngSpr.loadGraphic(Paths.image('newgrounds_logo_classic'));
		}
		else if (FlxG.random.bool(30))
		{
			ngSpr.loadGraphic(Paths.image('newgrounds_logo_animated'), true, 600);
			ngSpr.animation.add('idle', [0, 1], 4);
			ngSpr.animation.play('idle');
			ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.55));
			ngSpr.y += 25;
		}
		else
		{
			ngSpr.loadGraphic(Paths.image('newgrounds_logo'));
			ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		}
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.data.antialiasing;
		ngSpr.visible = false;

		bf = new TitleBF(59.8, 126.95);
		bf.playAnimation('boyfriend idle dance');
		bf.visible = false;
		
		add(logoBl);
		add(credGroup);
		add(ngSpr);
		add(bf);

		if (initialized)
			skipIntro();
		else
			initialized = true;

	}

	// JSON data
	// nuh uh
	var enterPosition:FlxPoint = FlxPoint.get(100, 576);

	var musicBPM:Float = 130;

	function getIntroTextShit():Array<Array<String>>
	{
		#if MODS_ALLOWED
		var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/introText.txt');
		#else
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		#end
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	private static var playJingle:Bool = false;

	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		#if debug
		if (controls.FAVORITE)
			moveToAttract();
		#end
		if (!cheatActive && skippedIntro)
			cheatCodeShit();

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT || (TouchUtil.justReleased && !SwipeUtil.swipeAny);

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if(enterTimer != null && pressedEnter){
			enterTimer.cancel();
			enterTimer.onComplete(enterTimer);
			enterTimer = null;
		}

		if (newTitle)
		{
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2)
				titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (pressedEnter)
			{

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				enterTimer = new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate)
					{
						MusicBeatState.switchState(new OutdatedState());
					}
					else
					{
						if (cheatActive)
						{
							FlxG.sound.playMusic(Paths.music('FlexRack'), 0);
							FlxG.sound.music.fadeIn(4, 0, 0.7);
						}
						FlxTransitionableState.skipNextTransIn = true;
						MusicBeatState.switchState(new MainMenuState());
					}

					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if (swagShader != null)
		{
			if (cheatActive && TouchUtil.pressed || controls.UI_LEFT)
				swagShader.hue -= elapsed * 0.1;
			if (controls.UI_RIGHT)
				swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			if (ClientPrefs.data.vibrating)
				lime.ui.Haptic.vibrate(100, 100);

			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;

			if (credGroup != null && textGroup != null)
			{
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if (textGroup != null && credGroup != null)
		{
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; // Basically curBeat but won't be skipped if you hold the tab or resize the screen

	public static var closedState:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
			logoBl.animation.play('bump', true);

		if (curBeat % 2 == 0)
			bf.playAnimation('boyfriend idle dance');

		if (cheatActive && this.curBeat % 2 == 0 && swagShader != null)
			swagShader.hue += 0.125;
		
		if (!closedState)
		{
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					// FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('FlexRack'), 0);
					#if VIDEOS_ALLOWED
						FlxG.sound.music.onComplete = moveToAttract;
					#end
					FlxG.sound.music.fadeIn(4, 0, 0.7);
					createCoolText(['Funkin Crew Inc']);
				case 2:
					addMoreText('Psych Engine Team');
					addMoreText('PSlice Engine Team');
					//'Psych Engine Team', 'PSlice Team', 'vs Guy Plus Team'
				case 3:
					addMoreText('vs Guy Plus Team');
				case 4:
					addMoreText('present');
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Not associated', 'with'], -40);
				case 8:
					addMoreText('newgrounds', -40);
					ngSpr.visible = true;
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				case 10:
					createCoolText([curWacky[0]]);
					// createCoolText(['hello']);
				case 12:
					addMoreText(curWacky[1]);
					// addMoreText('elomentoplayz');
				case 13:
					deleteCoolText();
				case 14:
					addMoreText('vs');
				case 15:
					addMoreText('guy');
				case 16:
					addMoreText('plus'); // credTextShit.text += '\nFunkin';

				case 17:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			#if VIDEOS_ALLOWED
				FlxG.sound.music.onComplete = moveToAttract;
			#end
			{
				remove(ngSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 4);

				bf.visible = true;
			}
			skippedIntro = true;
		}
	}

	// Cheat code shit
	var cheatArray:Array<Int> = [0x0001, 0x0010, 0x0001, 0x0010, 0x0100, 0x1000, 0x0100, 0x1000];
	var curCheatPos:Int = 0;
	var cheatActive:Bool = false;

	function cheatCodeShit():Void
	{
		if (SwipeUtil.swipeAny || FlxG.keys.justPressed.ANY)
		{
			if (controls.NOTE_DOWN_P || controls.UI_DOWN_P || SwipeUtil.swipeUp)
				codePress(FlxDirectionFlags.DOWN);
			if (controls.NOTE_UP_P || controls.UI_UP_P  || SwipeUtil.swipeDown)
				codePress(FlxDirectionFlags.UP);
			if (controls.NOTE_LEFT_P || controls.UI_LEFT_P || SwipeUtil.swipeRight)
				codePress(FlxDirectionFlags.LEFT);
			if (controls.NOTE_RIGHT_P || controls.UI_RIGHT_P || SwipeUtil.swipeLeft)
				codePress(FlxDirectionFlags.RIGHT);
		}
	}

	function codePress(input:Int)
	{
		if (input == cheatArray[curCheatPos])
		{
			curCheatPos += 1;
			if (curCheatPos >= cheatArray.length)
				startCheat();
		}
		else
			curCheatPos = 0;

		trace(input);
	}

	function startCheat():Void
	{
		cheatActive = true;

		// var spec:SpectogramSprite = new SpectogramSprite(FlxG.sound.music);

		FlxG.sound.playMusic(Paths.music('girlfriendsRingtone'), 0);
		Conductor.bpm = 160; // GF's ringnote has different BPM

		FlxG.sound.music.fadeIn(4.0, 0.0, 1.0);

		FlxG.camera.flash(FlxColor.WHITE, 1);
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
	}

	/**
	 * After sitting on the title screen for a while, transition to the attract screen.
	 */
	function moveToAttract():Void
	{	
		#if ATTRACT_ALLOWED
		if(!Std.isOfType(FlxG.state,TitleState)) return;
		FlxG.switchState(() -> new AttractState());
		#end
	}
}
