package sinco;

import lime.app.Application;

class Constants
{
	public static var GIT_PAGE(get, never):String;

	public static function get_GIT_PAGE():String
	{
		#if FUNKIN_SMP
		trace('FUNKIN_SMP');
		return 'FunkinSMP';
		#end

		return 'VsGuyPlus';
	}

	public static var SAVE(get, never):String;

	public static function get_SAVE():String
	{
		#if FUNKIN_SMP
		return 'funkin_smp';
		#end

		return 'guy+';
	}

	public static var DEFAULT_FONT:String = 'vcr.tff';
	public static var MINECRAFT_FONT:String = 'mc.tff';

	public static var PSYCH_VERSION:String = '1.0';

	public static var PSLICE_VERSION:String = '2.1';

	public static var MOD_VERSION:String = '1.0';
	public static var MOD_VERSION_REG:String = '1.0';

	public static function initModVer() {
		MOD_VERSION_REG = Application.current.meta.get('version');
		MOD_VERSION = MOD_VERSION_REG #if debug + '-#${Application.current.meta.get('build')}' #end;
	}

	public static var FUNKIN_EMULATION_VERSION:String = '0.5.1';

	public static var WINDOW_TITLE_PREFIX:String = "Funkin SMP";

	public static var ENGINE:String = "Paint Engine";
	public static var ENGINE_VERSION:String = "2.1";

	public static function getEngineString():String
		return '$ENGINE $ENGINE_VERSION';

	public static function getEngineStringWithPSliceVer():String
		return '${getEngineString()} (PSlice $PSLICE_VERSION)';

	public static function getEngineText():FlxText
	{
		var engineWatermark:FlxText = new FlxText(10, 10, 0, getEngineString(), 16);
		engineWatermark.setFormat(Paths.font(DEFAULT_FONT), 16, FlxColor.WHITE, RIGHT);
		engineWatermark.scrollFactor.set(0, 0);
		engineWatermark.x = FlxG.width - engineWatermark.width / 1;
		engineWatermark.y = 4;
		engineWatermark.alpha = 0.5;
		engineWatermark.color = FlxColor.WHITE;
		engineWatermark.visible = false;
		return engineWatermark;
	}
}
