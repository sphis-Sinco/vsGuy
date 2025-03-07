package states;

import objects.MenuBG;
import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:MenuBG;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new MenuBG('menuDesat');
		bg.scale.set(1, 1);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled)
			pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [
			// Name - Icon name - Description - Link - BG Color
			['vs Guy Plus Team'],
			[
				'Sinco',
				'sinco',
				'Director, Artist, Animator, Composer, Programmer',
				'https://www.youtube.com/@sphis-Sinco',
				'00ff00'
			],
			[
				'Djotta Flow',
				'djotta',
				'Co-director, Artist, Animator, Composer, Programmer',
				'https://www.youtube.com/@djotta11',
				'0000ff'
			],
			[
				'TJ The Hedgehog',
				'tj',
				'Artist, Animator',
				'https://www.youtube.com/@thatonetj',
				'00ffff'
			],
			[
				'Og Foxer',
				'ogfoxer',
				'Artist, Animator, Composer',
				'https://www.youtube.com/@OgFoxerEpic',
				'ff6600'
			],
			[
				'Bonky',
				'face',
				'Composer',
				'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
				'555555'
			],
			[""],
			['P-Slice Engine Team'],
			[
				'Mikolka9144',
				'mikolka',
				'Did everything for P-slice',
				'https://gamebanana.com/members/3329541',
				'2ebcfa'
			],
			[
				'mcagabe19',
				'lily',
				'Porter of P-slice for mobile devices and creator of linc_luajit-rewritten (used for mobile builds)',
				'https://youtube.com/@mcagabe19',
				'FFE7C0'
			],
			[""],
			["Psych Engine Team"],
			[
				"Shadow Mario",
				"shadowmario",
				"Main Programmer and Head of Psych Engine",
				"https://ko-fi.com/shadowmario",
				"444444"
			],
			[
				"Riveren",
				"riveren",
				"Main Artist/Animator of Psych Engine",
				"https://x.com/riverennn",
				"14967B"
			],
			[""],
			["Former Engine Members"],
			[
				"bb-panzu",
				"bb",
				"Ex-Programmer of Psych Engine",
				"https://x.com/bbsub3",
				"3E813A"
			],
			[""],
			["Engine Contributors"],
			[
				"crowplexus",
				"crowplexus",
				"HScript Iris, Input System v3, and Other PRs",
				"https://github.com/crowplexus",
				"CFCFCF"
			],
			[
				"Kamizeta",
				"kamizeta",
				"Creator of Pessy, Psych Engine's mascot.",
				"https://www.instagram.com/cewweey/",
				"D21C11"
			],
			[
				"MaxNeton",
				"maxneton",
				"Loading Screen Easter Egg Artist/Animator.",
				"https://bsky.app/profile/maxneton.bsky.social",
				"3C2E4E"
			],
			[
				"Keoiki",
				"keoiki",
				"Note Splash Animations and Latin Alphabet",
				"https://x.com/Keoiki_",
				"D2D2D2"
			],
			[
				"SqirraRNG",
				"sqirra",
				"Crash Handler and Base code for\nChart Editor's Waveform",
				"https://x.com/gedehari",
				"E1843A"
			],
			[
				"EliteMasterEric",
				"mastereric",
				"Runtime Shaders support and Other PRs",
				"https://x.com/EliteMasterEric",
				"FFBD40"
			],
			[
				"MAJigsaw77",
				"majigsaw",
				".MP4 Video Loader Library (hxvlc)",
				"https://x.com/MAJigsaw77",
				"5F5F5F"
			],
			[
				"Tahir Toprak Karabekiroglu",
				"tahir",
				"Note Splash Editor and Other PRs",
				"https://x.com/TahirKarabekir",
				"A04397"
			],
			[
				"iFlicky",
				"flicky",
				"Composer of Psync and Tea Time\nAnd some sound effects",
				"https://x.com/flicky_i",
				"9E29CF"
			],
			[
				"KadeDev",
				"kade",
				"Fixed some issues on Chart Editor and Other PRs",
				"https://x.com/kade0912",
				"64A250"
			],
			[
				"superpowers04",
				"superpowers04",
				"LUA JIT Fork",
				"https://x.com/superpowers04",
				"B957ED"
			],
			[
				"CheemsAndFriends",
				"cheems",
				"Creator of FlxAnimate",
				"https://x.com/CheemsnFriendos",
				"E1E1E1"
			],
			[""],

			["The Funkin' Crew Inc"],
			[
				"ninjamuffin99",
				"ninjamuffin99",
				"Lead Programmer of Friday Night Funkin'",
				"https://x.com/ninja_muffin99",
				"CF2D2D"
			],
			[
				"PhantomArcade",
				"phantomarcade",
				"Lead Animator of Friday Night Funkin'",
				"https://x.com/PhantomArcade3K",
				"FADC45"
			],
			[
				"evilsk8r",
				"evilsk8r",
				"Lead Artist of Friday Night Funkin'",
				"https://x.com/evilsk8r",
				"5ABD4B"
			],
			[
				"kawaisprite",
				"kawaisprite",
				"Lead Composer of Friday Night Funkin'",
				"https://x.com/kawaisprite",
				"378FC7"
			],

			[""],
			["Psych Engine Discord"],
			["Join the Psych Ward!", "discord", "", "https://discord.gg/2ka77eMXDv", "5165F6"]
		];

		for (i in defaultList)
			creditsStuff.push(i);

		for (i => credit in creditsStuff)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, credit[0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if (!isSelectable)
			{
				optionText.alignment = CENTERED;
				continue;
			}

			if (credit[5] != null)
				Mods.currentModDirectory = credit[5];
			var cred = credit[1];
			var str:String = 'credits/missing_icon';
			var animated:Bool = false;
			var scale:Float = 1;
			if (cred != null && cred.length > 0)
			{
				var fileName = 'credits/' + cred;
				if (cred == 'sinco' || cred == 'djotta' || cred == 'tj' || cred == 'ogfoxer')
					scale = 0.5;
				if (Paths.fileExists('images/$fileName.xml', TEXT))
					animated = true;
				if (Paths.fileExists('images/$fileName.png', IMAGE))
					str = fileName;
				else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE))
					str = fileName + '-pixel';
			}
			var icon:AttachedSprite;

			if (animated)
				icon = new AttachedSprite(str, cred, null, true);
			else
				icon = new AttachedSprite(str);

			if (str.endsWith('-pixel'))
				icon.antialiasing = false;
			icon.xAdd = optionText.width + 10;
			if (cred == 'sinco')
			{
				icon.xAdd -= 40;
				icon.yAdd -= 20;
			}
			icon.scale.set(scale, scale);
			icon.sprTracker = optionText;
			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
			Mods.currentModDirectory = '';
			if (curSelected == -1)
				curSelected = i;
		}

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER /*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		// descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();
		#if TOUCH_CONTROLS_ALLOWED
		addTouchPad('UP_DOWN', 'A_B');
		#end
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!quitting)
		{
			if (creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if (FlxG.keys.pressed.SHIFT)
					shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if (controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if (controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4))
			{
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}

		for (item in grpOptions.members)
		{
			if (!item.bold)
			{
				var lerpVal:Float = Math.exp(-elapsed * 12);
				if (item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(item.x - 70, lastX, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(200 + -40 * Math.abs(item.targetY), item.x, lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
		{
			curSelected = FlxMath.wrap(curSelected + change, 0, creditsStuff.length - 1);
		}
		while (unselectableCheck(curSelected));

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		// trace('The BG color is: $newColor');
		if (newColor != intendedColor)
		{
			intendedColor = newColor;
			FlxTween.cancelTweensOf(bg);
			FlxTween.color(bg, 1, bg.color, intendedColor);
		}

		for (num => item in grpOptions.members)
		{
			item.targetY = num - curSelected;
			if (!unselectableCheck(num))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		if (descText.text.trim().length > 0)
		{
			descText.visible = descBox.visible = true;
			descText.y = FlxG.height - descText.height + offsetThing - 60;

			if (moveTween != null)
				moveTween.cancel();
			moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

			descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
			descBox.updateHitbox();
		}
		else
			descText.visible = descBox.visible = false;
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = Paths.mods(folder + '/data/credits.txt');

		#if TRANSLATIONS_ALLOWED
		// trace('/data/credits-${ClientPrefs.data.language}.txt');
		var translatedCredits:String = Paths.mods(folder + '/data/credits-${ClientPrefs.data.language}.txt');
		#end

		if (#if TRANSLATIONS_ALLOWED (FileSystem.exists(translatedCredits) && (creditsFile = translatedCredits) == translatedCredits)
			|| #end FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for (i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if (arr.length >= 5)
					arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool
	{
		return creditsStuff[num].length <= 1;
	}
}
