package
{
	import net.flashpunk.*;
	import net.flashpunk.debug.*;
	import net.flashpunk.utils.*;
	
	import flash.net.*;
	
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public static const TW:int = 16;
		public static const TILES_WIDE:int = 320/16;
		public static const TILES_HIGH:int = 240/16;
		
		public static var devMode:Boolean = true;
		
		public static const so:SharedObject = SharedObject.getLocal("draknek/hamelin", "/");
		
		public function Main () 
		{
			super(320, 240, 60, true);
			
			FP.screen.scale = 2;
		}
		
		public override function init (): void
		{
			LevelList.init();
			Editor.init();
			if (devMode) {
				CopyPaste.init(stage, pasteCallback);
			}
			
			FP.world = new Level();
		}
		
		public override function update (): void
		{
			if (Input.pressed(FP.console.toggleKey)) {
				// Doesn't matter if it's called when already enabled
				FP.console.enable();
			}
			
			super.update();
		}
		
		public function pasteCallback (data:String): void
		{
			
		}
		
	}
}

