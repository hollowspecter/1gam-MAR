#if nme

import de.blogspot.hollowspecter.test.Main;
import nme.Assets;
import nme.events.Event;


class ApplicationMain {
	
	static var mPreloader:NMEPreloader;

	public static function main () {
		
		var call_real = true;
		
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		
		if (loaded < total || true) /* Always wait for event */ {
			
			call_real = false;
			mPreloader = new com.haxepunk.Preloader();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener (nme.events.Event.ENTER_FRAME, onEnter);
			
		}
		
		
		#if !fdb
		haxe.Log.trace = flashTrace;
		#end
		
		if (call_real)
			begin ();
	}

	#if !fdb
	private static function flashTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		var className = pos.className.substr(pos.className.lastIndexOf('.') + 1);
		var message = className+"::"+pos.methodName+":"+pos.lineNumber+": " + v;
		
        if (flash.external.ExternalInterface.available)
			flash.external.ExternalInterface.call("console.log", message);
		else untyped flash.Boot.__trace(v, pos);
    }
	#end
	
	private static function begin () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(de.blogspot.hollowspecter.test.Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod (de.blogspot.hollowspecter.test.Main, Reflect.field (de.blogspot.hollowspecter.test.Main, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(de.blogspot.hollowspecter.test.Main, []);
			if (Std.is (instance, nme.display.DisplayObject)) {
				nme.Lib.current.addChild(cast instance);
			}	
		}
		
	}

	static function onEnter (_) {
		
		var loaded = nme.Lib.current.loaderInfo.bytesLoaded;
		var total = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			mPreloader.addEventListener (Event.COMPLETE, preloader_onComplete);
			mPreloader.onLoaded();
			
		}
		
	}

	public static function getAsset (inName:String):Dynamic {
		
		
		if (inName=="gfx/debug/console_debug.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_debug.png");
         
		
		if (inName=="gfx/debug/console_logo.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_logo.png");
         
		
		if (inName=="gfx/debug/console_output.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_output.png");
         
		
		if (inName=="gfx/debug/console_pause.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_pause.png");
         
		
		if (inName=="gfx/debug/console_play.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_play.png");
         
		
		if (inName=="gfx/debug/console_step.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_step.png");
         
		
		if (inName=="gfx/preloader/haxepunk.png")
			 
            return Assets.getBitmapData ("gfx/preloader/haxepunk.png");
         
		
		if (inName=="font/04B_03__.ttf")
			 
			 return Assets.getFont ("font/04B_03__.ttf");
		 
		
		if (inName=="gfx/block.png")
			 
            return Assets.getBitmapData ("gfx/block.png");
         
		
		if (inName=="gfx/car.png")
			 
            return Assets.getBitmapData ("gfx/car.png");
         
		
		if (inName=="gfx/car_animation.png")
			 
            return Assets.getBitmapData ("gfx/car_animation.png");
         
		
		if (inName=="gfx/debug/console_debug.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_debug.png");
         
		
		if (inName=="gfx/debug/console_logo.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_logo.png");
         
		
		if (inName=="gfx/debug/console_output.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_output.png");
         
		
		if (inName=="gfx/debug/console_pause.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_pause.png");
         
		
		if (inName=="gfx/debug/console_play.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_play.png");
         
		
		if (inName=="gfx/debug/console_step.png")
			 
            return Assets.getBitmapData ("gfx/debug/console_step.png");
         
		
		if (inName=="gfx/ppl/1.png")
			 
            return Assets.getBitmapData ("gfx/ppl/1.png");
         
		
		if (inName=="gfx/ppl/faces.png")
			 
            return Assets.getBitmapData ("gfx/ppl/faces.png");
         
		
		if (inName=="gfx/tileset.png")
			 
            return Assets.getBitmapData ("gfx/tileset.png");
         
		
		if (inName=="gfx/tileset_scaled.png")
			 
            return Assets.getBitmapData ("gfx/tileset_scaled.png");
         
		
		if (inName=="sfx/acceleration.wav")
			 
            return Assets.getSound ("sfx/acceleration.wav");
         
		
		if (inName=="sfx/car.wav")
			 
            return Assets.getSound ("sfx/car.wav");
         
		
		if (inName=="font/04B_03__.ttf")
			 
			 return Assets.getFont ("font/04B_03__.ttf");
		 
		
		if (inName=="maps/test.tmx")
			 
			 return Assets.getText ("maps/test.tmx");
         
		
		
		return null;
		
	}
	
	
	private static function preloader_onComplete (event:Event):Void {
		
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		
		begin ();
		
	}
	
}

class NME_gfx_debug_console_debug_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_logo_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_output_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_pause_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_play_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_step_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_preloader_haxepunk_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_font_04b_03___ttf extends nme.text.Font { }
class NME_gfx_block_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_car_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_car_animation_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_debug_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_logo_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_output_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_pause_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_play_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_debug_console_step_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_ppl_1_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_ppl_faces_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_tileset_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_gfx_tileset_scaled_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_sfx_acceleration_wav extends nme.media.Sound { }
class NME_sfx_car_wav extends nme.media.Sound { }
class NME_font_5 extends nme.text.Font { }
class NME_maps_test_tmx extends nme.utils.ByteArray { }


#else

import de.blogspot.hollowspecter.test.Main;

class ApplicationMain {
	
	public static function main () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(de.blogspot.hollowspecter.test.Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod (de.blogspot.hollowspecter.test.Main, Reflect.field (de.blogspot.hollowspecter.test.Main, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(de.blogspot.hollowspecter.test.Main, []);
			if (Std.is (instance, flash.display.DisplayObject)) {
				flash.Lib.current.addChild(cast instance);
			}
		}
		
	}

}

#end
