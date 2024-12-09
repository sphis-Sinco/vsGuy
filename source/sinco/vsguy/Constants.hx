package sinco.vsguy;

class Constants
{
    public static var WINDOW_TITLE_PREFIX:String = "FNF: vs Guy Plus";

	public static var ENGINE:String = "Guy Engine";
	public static var ENGINE_VERSION:String = "v2.0";

    public static function getEngineString():String
        return '$ENGINE $ENGINE_VERSION';
    
    public static function getEngineText():FlxText
    {
		var engineWatermark:FlxText = new FlxText(10, 10, 0, getEngineString(), 16);
		engineWatermark.setFormat(Paths.font("comicsans.ttf"), 16, FlxColor.WHITE, RIGHT);
		engineWatermark.scrollFactor.set(0, 0);
		engineWatermark.x = FlxG.width - engineWatermark.width / 1;
		engineWatermark.y = 4;
		engineWatermark.alpha = 0.5;
		engineWatermark.color = FlxColor.WHITE;
		engineWatermark.visible = false;
		return engineWatermark;
    }
}