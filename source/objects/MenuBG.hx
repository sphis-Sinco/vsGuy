package objects;

class MenuBG extends FlxSprite
{
    override public function new(bg:String = 'menuBG', ?yScroll:Float = 0)
    {
        loadGraphic(Paths.image('menuBG'));

        antialiasing = ClientPrefs.data.antialiasing;
		scrollFactor.set(0, yScroll);
		setGraphicSize(Std.int(width * 1.175));
		updateHitbox();
		screenCenter();

        setPosition(-80);

        super(x,y);    
    }
}