package sinco.vsguy.testing.dlc;

class DLCSelector extends MusicBeatState
{
	override public function create()
	{
		trace(Mods.parseList().all);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
