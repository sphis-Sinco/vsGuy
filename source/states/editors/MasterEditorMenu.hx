package states.editors;

import objects.MenuBG;
import openfl.events.UncaughtErrorEvent;
import mikolka.compatibility.VsliceOptions;
import flixel.math.FlxRandom;
import backend.WeekData;
import mikolka.vslice.results.ResultState;
import objects.Character;
import states.MainMenuState;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'Chart Editor', 
		'Character Editor', 
		'Stage Editor', 
		'Week Editor', 
		'Test stickers', 
		'Menu Character Editor', 
		'Dialogue Editor', 
		'Dialogue Portrait Editor',
		#if debug
		'Crash the game',
		#end
		'Note Splash Editor', 
		'Preview results (perfect)', 
		'Preview results (excellent)', 
		'Preview results (great)', 
		'Preview results (good)', 
		'Preview results (shit)'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var directories:Array<String> = [null];

	private var curSelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editors Main Menu", null);
		#end

		var bg:MenuBG = new MenuBG('menuDesat');
		bg.scrollFactor.set();
		bg.color = 0xFF4CAF50;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(90, 320, options[i], true);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
			leText.snapToPosition();
		}
		changeSelection();

		FlxG.mouse.visible = false;

		#if TOUCH_CONTROLS_ALLOWED
		addTouchPad('UP_DOWN', 'A_B');
		#end
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch (options[curSelected])
			{
				case 'Chart Editor': // felt it would be cool maybe
					LoadingState.loadAndSwitchState(new ChartingState(), false);
				case 'Character Editor':
					LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
				case 'Stage Editor':
					LoadingState.loadAndSwitchState(new StageEditorState());
				case 'Week Editor':
					MusicBeatState.switchState(new WeekEditorState());
				case 'Menu Character Editor':
					MusicBeatState.switchState(new MenuCharacterEditorState());
				case 'Dialogue Editor':
					LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
				case 'Dialogue Portrait Editor':
					LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
				case 'Note Splash Editor':
					MusicBeatState.switchState(new NoteSplashEditorState());
				case 'Test stickers':
					MusicBeatState.switchState(new StickerTest());
				#if debug
				case 'Crash the game':{
					@:privateAccess
					openfl.Lib.current.loaderInfo.uncaughtErrorEvents.dispatchEvent(
						new UncaughtErrorEvent(
							openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR,
							true,true,new openfl.errors.Error("The devs are too stupid and they write way too long errors")));
				}
				#end
				case 'Preview results (perfect)':
					runResults(200);
				case 'Preview results (excellent)':
					runResults(190);
				case 'Preview results (great)':
					runResults(160);
				case 'Preview results (good)':
					runResults(150);
				case 'Preview results (shit)':
					runResults(30);
			}
			FlxG.sound.music.volume = 0;
		}

		for (num => item in grpTexts.members)
		{
			item.targetY = num - curSelected;
			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
		super.update(elapsed);
	}

	function runResults(lol:Int)
	{
		PlayState.storyDifficultyColor = 0xFFFF0000;
		Difficulty.resetList();
		PlayState.storyDifficulty = 2;
		var results = new ResultState({
			storyMode: false,
			prevScoreRank: EXCELLENT,
			title: "Cum Song Erect by Kawai Sprite",
			songId: "cum",
			difficultyId: "nightmare",
			isNewHighscore: true,
			characterId: '',
			scoreData: {
				score: 1_234_567,
				accPoints: lol,
				sick: 199,
				good: 0,
				bad: 0,
				shit: 0,
				missed: 1,
				combo: 0,
				maxCombo: 69,
				totalNotesHit: 200,
				totalNotes: 200 // 0,
			},
		});
		@:privateAccess
		results.playerCharacterId = VsliceOptions.LAST_MOD.char_name;
		MusicBeatState.switchState(results);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
	}
}
