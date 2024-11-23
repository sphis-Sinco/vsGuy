package objects;

class MenuBG extends FlxSprite
{
    override public function new(bg:String = 'menuBG', ?yScroll:Float = 0)
    {
        super(x,y);

        loadGraphic(Paths.image('menuBG'));

        antialiasing = ClientPrefs.data.antialiasing;
		scrollFactor.set(0, yScroll);
		setGraphicSize(Std.int(width * 1.175));
		updateHitbox();

        setPosition(-80);
		screenCenter();  
    }
}