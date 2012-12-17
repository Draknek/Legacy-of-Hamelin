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
			
			type = "player";
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.add("jig", [0,1,2], 1 / 30);
			
			sprite.play("jig");
			
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
			
			var toX:int = x+speed*dx;
			var toY:int = y+speed*dy;
			
			if (toX < 0 || toY < 0 || toX >= FP.width || toY >= FP.height) {
				return;
			}
			
			if (collide("solid", toX, toY) || collide("water", toX, toY) || collide("sewer", toX, toY)) {
				return;
			}
			
			var rat:Rat = collide("rat", toX, toY) as Rat;
			
			if (rat) {
				rat.tryMoving(dx, dy);
				
				if (rat.x == rat.toX && rat.y == rat.toY) {
					return;
				}
			}
			
			for each (rat in Level(world).rats) {
				rat.tryMoving(dx, dy);
			}
			
			moveTween = FP.tween(this, {x: toX, y: toY}, MOVE_TIME, {tweener:FP.world});
			
			//Audio.playNote();
		}
	}
}

