package substates;

import states.MainMenuState;
import flixel.FlxG;
import flixel.FlxState;

class StickerSubState extends MusicBeatSubstate
{
  var targetState:StickerSubState->FlxState;

  public function new(?oldStickers:Dynamic, ?targetState:StickerSubState->FlxState):Void
  {
    super();

    this.targetState = (targetState == null) ? ((sticker) -> new MainMenuState()) : targetState;

    FlxG.switchState(targetState(this));
  }
}