package sinco.vsguy.states.new_title;

class TitleScreen extends MusicBeatState
{
	public var backdrop:FlxSprite;
	public var bf:TitleBF;
	public var bars:FlxSprite;
	public var press_play:FlxSprite;
	public var logo:FlxSprite;

    override public function new()
    {
        super();

        Conductor.set_bpm(130);

		bf = new TitleBF(0,0);
		bf.playAnimation('boyfriend idle dance', false, false, true);
	}

	override public function create()
	{
        add(bf);

		super.create();
	}

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}