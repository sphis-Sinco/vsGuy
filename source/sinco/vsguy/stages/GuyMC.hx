package sinco.vsguy.stages;

import mikolka.compatibility.VsliceOptions;
import openfl.display.BlendMode;
import shaders.AdjustColorShader;
import backend.BaseStage;

class GuyMC extends BaseStage {
	override function create()
	{
		var bg:BGSprite = new BGSprite('guyhouse', 0, 0);
        bg.scale.set(1,1);
		bg.antialiasing = false;
		add(bg);
	}
    override function createPost() {
        super.createPost();
    }
    override function startCountdown():Bool {
        return super.startCountdown();
    }
}