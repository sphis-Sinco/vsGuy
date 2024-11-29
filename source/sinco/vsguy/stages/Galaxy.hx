package sinco.vsguy.stages;

import mikolka.compatibility.VsliceOptions;
import openfl.display.BlendMode;
import shaders.AdjustColorShader;
import backend.BaseStage;

class Galaxy extends BaseStage {
	override function create()
	{
		var bg:BGSprite = new BGSprite('galaxy', 729, -170);
		add(bg);
	}
    override function createPost() {
        super.createPost();
        if(VsliceOptions.SHADERS){
            gf.shader = makeCoolShader(-9,0,-30,-4);
            dad.shader = makeCoolShader(-32,0,-33,-23);
            boyfriend.shader = makeCoolShader(12,0,-23,7);
        }
    }
    override function startCountdown():Bool {
        return super.startCountdown();
    }
    function makeCoolShader(hue:Float,sat:Float,bright:Float,contrast:Float) {
        var coolShader = new AdjustColorShader();
        coolShader.hue = hue;
        coolShader.saturation = sat;
        coolShader.brightness = bright;
        coolShader.contrast = contrast;
        return coolShader;
    }
}