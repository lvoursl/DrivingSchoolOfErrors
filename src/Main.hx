package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import openfl.display.StageDisplayState;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author lvoursl
 */

class Main extends Sprite 
{
	var inited:Bool;
	var game:Game;
	var frame:Int = 0;
	public static var keys:Map<Int,Bool> = new Map();
	var car:Car;
	var scale:Float = 1;
	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		
		game = new Game();
		addChild(game);
		car = new Car();
		addChild(car);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, car.keyDownHandler);
		stage.addEventListener(KeyboardEvent.KEY_UP, car.keyUpHandler);
		stage.addEventListener(Event.ENTER_FRAME, car.ModifyCar);
		stage.addEventListener(Event.ENTER_FRAME, onFrame);
		//addEventListener(Event.ENTER_FRAME, car.Update, false, 0 , true);
		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	public function keyReleased_handler(e:KeyboardEvent) { 
		keys[e.keyCode] = false;
	}
	
	public function keyPressed_handler(e:KeyboardEvent) {
		keys[e.keyCode] = true;
	}
	
	public function onFrame(e:Event) {
		
		for (tile in game.arrayOfFields) {
			if (car.bmp.hitTestObject(tile)) {
				//car.bmp.scaleX = 0.5 / scale;
				//car.bmp.scaleY = 0.5 / scale;
				/*car.bmp.width = car.bmp.width / scale;
				car.bmp.height = car.bmp.height / scale;
				scale++;
				car.setDefault();*/
				

				if (scale < 1.6) {
					car.bmp.width = car.bmp.width / scale;
					car.bmp.height = car.bmp.height / scale;
					scale += 0.1;
				}
				trace(scale);
				car.setDefault();				
				break;
			}
		}
		// восстановить дефолтные настройки машины путем обнуления переменных
		// походу тайлы не там, где спавим их, т.к. коллизия происходит раньше, еще до тайла
	}
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
