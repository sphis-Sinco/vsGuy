package substates;

import mikolka.compatibility.VsliceOptions;
import states.MainMenuState;
import flixel.FlxSprite;
import haxe.Json;
import lime.utils.Assets;
// import flxtyped group
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxSort;
import flixel.addons.transition.FlxTransitionableState;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import flixel.FlxState;

using Lambda;
using mikolka.funkin.IteratorTools;
using StringTools;
using mikolka.funkin.utils.ArrayTools;

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