package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Child extends Entity
	{
		[Embed(source="images/child.png")]
		public static const Gfx: Class;
		
		public var hasMoved:Boolean = false;
		
		public var toX:int;
		public var toY:int;
		
		public var sprite:Spritemap;
		
		public var moveTween:Tween;
		
		public function Child (_x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			
			type = "solid";
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			sprite.add("walk", [0,1,2], 0.1);
			
			sprite.frame = 0;
			
			graphic = sprite;
		}
		
		public function brainwash ():void
		{
			type = "child";
			sprite.play("walk");
		}
		
		public override function update ():void
		{
			//layer = -y;
		}
		
		public function tryMoving (dx:int, dy:int): void
		{
			if (hasMoved || ! active) return;
			
			hasMoved = true;
			
			toX = x;
			toY = y;
			
			var speed:int = Main.TW;
			
			var tryX:int = x+speed*dx;
			var tryY:int = y+speed*dy;
			
			if (collide("solid", tryX, tryY)) {
				return;
			}
			
			if (collide("water", tryX, tryY)) {
				return;
			}
			
			if (collide("sewer", tryX, tryY)) {
				return;
			}
			
			var child:Child = collide("child", tryX, tryY) as Child;
			
			if (child) {
				child.tryMoving(dx, dy);
				
				if (child.x == child.toX && child.y == child.toY) {
					return;
				}
			}
			
			toX = tryX;
			toY = tryY;
			
			var tweenTime:int = Player.MOVE_TIME;
			
			moveTween = FP.tween(this, {x: toX, y: toY}, tweenTime, stopWalk);
		}
		
		public function stopWalk ():void
		{
			if (x < 0 || y < 0 || x >= FP.width || y >= FP.height) {
				active = false;
				visible = false;
				collidable = false;
				FP.remove(Level(world).children, this);
			}
		}
	}
}