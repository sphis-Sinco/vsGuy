package mikolka.vslice;

import mikolka.compatibility.VsliceOptions;
import mikolka.compatibility.ModsHelper;
import flixel.FlxState;
#if !LEGACY_PSYCH
import states.TitleState;
#end
import openfl.events.ErrorEvent;
import openfl.display.BitmapData;
// crash handler stuff
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;

using StringTools;

class CrashState extends FlxState
{
	var screenBelow:BitmapData = BitmapData.fromImage(FlxG.stage.window.readPixels());
	var textBg:FlxSprite;

	var EMessage:String;
	var callstack:Array<StackItem>;

	public function new(EMessage:String, callstack:Array<StackItem>)
	{
		this.EMessage = EMessage;
		this.callstack = callstack;
		super();
	}

	override function create()
	{
		if (Main.fpsVar != null)
			Main.fpsVar.visible = false;
		super.create();
		var previousScreen = new FlxSprite(0, 0, screenBelow);
		previousScreen.setGraphicSize(FlxG.width, FlxG.height);
		previousScreen.updateHitbox();

		textBg = new FlxSprite();
		FunkinTools.makeSolidColor(textBg, Math.floor(FlxG.width * 0.73), FlxG.height, 0x86000000);
		textBg.screenCenter();

		add(previousScreen);
		add(textBg);
		var error = collectErrorData();
		printError(error);
		saveError(error);
		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end
	}

	function collectErrorData():CrashData
	{
		var errorMessage = EMessage;

		var callStack:Array<StackItem> = callstack;
		var errMsg = new Array<Array<String>>();
		var errExtended = new Array<String>();
		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, pos_line, column):
					var line = new Array<String>();
					switch (s)
					{
						case Module(m):
							line.push("MD:" + m);
						case CFunction:
							line.push("Native function");
						case Method(classname, method):
							var regex = ~/(([A-Z]+[A-z]*)\.?)+/g;
							regex.match(classname);
							line.push("CLS:" + regex.matched(0) + ":" + method + "()");
						default:
							Sys.println(stackItem);
					}
					line.push("Line:" + pos_line);
					errMsg.push(line);
					errExtended.push('In file ${file}: ${line.join("  ")}');
				default:
					Sys.println(stackItem);
			}
		}
		return {
			message: errorMessage,
			trace: errMsg,
			extendedTrace: errExtended,
			date: Date.now().toString(),
			systemName: #if android 'Android' #elseif linux 'Linux' #elseif mac 'macOS' #elseif windows 'Windows' #else 'iOS' #end,
			activeMod: ModsHelper.getActiveMod()
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (TouchUtil.justReleased || FlxG.keys.justPressed.ENTER)
		{
			TitleState.initialized = false;
			TitleState.closedState = false;
			#if LEGACY_PSYCH
			if (Main.fpsVar != null)
				Main.fpsVar.visible = ClientPrefs.showFPS;
			#else
			if (Main.fpsVar != null)
				Main.fpsVar.visible = ClientPrefs.data.showFPS;
			#end
			FlxG.sound.pause();
			FlxTween.globalManager.clear();
			FlxG.resetGame();
		}
	}

	function printError(error:CrashData)
	{
		printToTrace('VS GUY + ${GuyConsts.MOD_VERSION}  (${error.message})');
		textNextY += 35;
		FlxTimer.wait(1 / 24, () ->
		{
			printSpaceToTrace();
			for (line in error.trace)
			{
				switch (line.length)
				{
					case 1:
						printToTrace(line[0]);
					case 2:
						var first_line = line[0].rpad(" ", 33).replace("_", "");
						printToTrace('${first_line}${line[1]}');
					default:
						printToTrace(" ");
				}
			}
			var remainingLines = 12 - error.trace.length;
			if (remainingLines > 0)
			{
				for (x in 0...remainingLines)
				{
					printToTrace(" ");
				}
			}
			// printToTrace('S8:00000000H   RA:80286034H   MM:86A20290H');
			printSpaceToTrace();
			printToTrace('RUNTIME INFORMATION');
			var date_split = error.date.split(" ");
			printToTrace('TIME:${date_split[1].rpad(" ", 9)} DATE:${date_split[0]}');
			printSpaceToTrace();
			printToTrace('REPORT TO github.com/sphis-Sinco/vsGuyPlus');
			printToTrace('PRESS ENTER TO RESTART');
		});
	}

	static function saveError(error:CrashData)
	{
		var errMsg = "";
		var dateNow:String = error.date;

		dateNow = dateNow.replace(' ', '_');
		dateNow = dateNow.replace(':', "'");

		errMsg += '\nUncaught Error: ' + error.message + "\n";
		for (x in error.extendedTrace)
		{
			errMsg += x + "\n";
		}
		errMsg += '----------\n';
		errMsg += 'Active mod: ${error.activeMod}\n';
		errMsg += 'Platform: ${error.systemName}\n';
		errMsg += '\n';
		errMsg += '\nPlease report this error to the GitHub page: https://github.com/sphis-Sinco/vsGuyPlus\n\n> Crash Handler written by: sqirra-rng';

		#if !LEGACY_PSYCH
		@:privateAccess // lazy
		backend.CrashHandler.saveErrorMessage(errMsg + '\n');
		#else
		var path = './crash/' + 'VsGuyPlus_' + dateNow + '.txt';
		File.saveContent(path, errMsg + '\n');
		Sys.println(errMsg);
		#end
		Sys.println(errMsg);
	}

	var textNextY = 5;

	function printToTrace(text:String):FlxText
	{
		var test_text = new FlxText(180, textNextY, 920, text.toUpperCase());
		test_text.setFormat(Paths.font('vcr.ttf'), 35, FlxColor.WHITE, LEFT);
		test_text.updateHitbox();
		add(test_text);
		textNextY += 35;
		return test_text;
	}

	function printSpaceToTrace()
	{
		textNextY += 10;
	}
}

typedef CrashData =
{
	message:String,
	trace:Array<Array<String>>,
	extendedTrace:Array<String>,
	date:String,
	systemName:String,
	activeMod:String
}
