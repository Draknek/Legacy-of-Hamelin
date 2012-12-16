package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Player extends Entity
	{
		[Embed(source="images/player.png")]
		public static const Gfx: Class;
		
		public var moveTween:Tween;
		
		public static const MOVE_TIME: Number = 16;
		
		public var sprite:Spritemap;
		
		public function Player (_x:Number = 0, _y:Number = 0)
		{
			x = _x;
			y = _y;
			
			type = "solid";
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			
			graphic = sprite;
		}
		
		public override function update (): void
		{
			if (moveTween && moveTween.active) {
				return;
			}
			
			var dx:int = int(Input.check(Key.RIGHT)) - int(Input.check(Key.LEFT));
			
			if (! dx) {
				var dy:int = int(Input.check(Key.DOWN)) - int(Input.check(Key.UP));
			}
			
			if (! dx && ! dy) return;
			
			var speed:int = Main.TW;
			
			moveTween = FP.tween(this, {x: x + speed*dx, y: y + speed*dy}, MOVE_TIME, {tweener:FP.world});
			
			//Audio.playNote();
		}
		
		private static var array:Array = [];
	}
}

