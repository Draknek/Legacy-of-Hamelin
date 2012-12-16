package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Rat extends Entity
	{
		[Embed(source="images/rat.png")]
		public static const Gfx: Class;
		
		public var hasMoved:Boolean = false;
		
		public var toX:int;
		public var toY:int;
		
		public var sprite:Spritemap;
		
		public var moveTween:Tween;
		
		public function Rat (_x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			
			type = "rat";
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			sprite.frame = 3;
			
			graphic = sprite;
		}
		
		public override function update (): void
		{
			
		}
		
		public function tryMoving (dx:int, dy:int): void
		{
			if (hasMoved) return;
			
			hasMoved = true;
			
			var speed:int = Main.TW;
			
			toX = x+speed*dx;
			toY = y+speed*dy;
			
			if (toX < 0 || toY < 0 || toX >= FP.width || toY >= FP.height) {
				toX = x;
				toY = y;
				return;
			}
			
			if (collide("solid", toX, toY) || collide("water", toX, toY)) {
				toX = x;
				toY = y;
				return;
			}
			
			var rat:Rat = collide("rat", toX, toY) as Rat;
			
			if (rat) {
				rat.tryMoving(dx, dy);
				
				if (rat.x == rat.toX && rat.y == rat.toY) {
					toX = x;
					toY = y;
					return;
				}
			}
			
			moveTween = FP.tween(this, {x: x + speed*dx, y: y + speed*dy}, Player.MOVE_TIME);
		}
	}
}

