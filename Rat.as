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
		
		public var direction:String;
		
		public function Rat (_x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			
			type = "rat";
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			
			var dirs:Array = ["down", "up", "left", "right"];
			
			var framesPerDirection:int = 4;
			
			for (var i:int = 0; i < dirs.length; i++) {
				var dirString:String = dirs[i];
				sprite.add(dirString, [i*framesPerDirection], 0.1);
				sprite.add("walk" + dirString,
					FP.frames(i*framesPerDirection, i*framesPerDirection + 4),
					0.25);
			}
			
			direction = "right";
			
			sprite.play(direction);
			
			graphic = sprite;
		}
		
		public override function update (): void
		{
			
		}
		
		public function tryMoving (dx:int, dy:int): void
		{
			if (hasMoved) return;
			
			hasMoved = true;
			
			toX = x;
			toY = y;
			
			if (type != "rat") return;
			
			if (dx < 0) direction = "left";
			else if (dx > 0) direction = "right";
			else if (dy < 0) direction = "up";
			else if (dy > 0) direction = "down";
			
			sprite.play(direction);
			
			var speed:int = Main.TW;
			
			var tryX:int = x+speed*dx;
			var tryY:int = y+speed*dy;
			
			if (tryX < 0 || tryY < 0 || tryX >= FP.width || tryY >= FP.height) {
				return;
			}
			
			if (collide("solid", tryX, tryY) || collide("water", tryX, tryY)) {
				return;
			}
			
			var rat:Rat = collide("rat", tryX, tryY) as Rat;
			
			if (rat) {
				rat.tryMoving(dx, dy);
				
				if (rat.x == rat.toX && rat.y == rat.toY) {
					return;
				}
			}
			
			toX = tryX;
			toY = tryY;
			
			var halfMove:Boolean = false;
			var slowMove:Boolean = false;
			
			tryX += speed*dx;
			tryY += speed*dy;
			
			if (collide("player", toX, toY)) {
				halfMove = true;
				slowMove = true;
			}
			else if (tryX < 0 || tryY < 0 || tryX >= FP.width || tryY >= FP.height) {
				halfMove = true;
			}
			else if (collide("solid", tryX, tryY) || collide("water", tryX, tryY)) {
				halfMove = true;
			}
			else if (rat && tryX == rat.toX && tryY == rat.toY) {
				halfMove = true;
			}
			else {
				rat = collide("rat", tryX, tryY) as Rat;
				
				if (rat) {
					rat.tryMoving(dx, dy);
					
					if (tryX == rat.toX && tryY == rat.toY) {
						halfMove = true;
					}
				}
				
				var sewer:Sewer = collide("sewer", toX, toY) as Sewer;
				
				if (sewer && ! sewer.full) {
					halfMove = true;
				}
			}
			
			if (! halfMove) {
				toX = tryX;
				toY = tryY;
			}
			
			sprite.play("walk" + direction);
			
			var tweenTime:int = Player.MOVE_TIME;
			
			if (halfMove && ! slowMove) tweenTime *= 0.5;
			
			moveTween = FP.tween(this, {x: toX, y: toY}, tweenTime, stopWalk);
		}
		
		public function stopWalk ():void
		{
			sprite.play(direction);
			
			var sewer:Sewer = collide("sewer", x, y) as Sewer;
			
			if (sewer && ! sewer.full) {
				sewer.addRat();
				visible = false;
				type = "";
			}
		}
	}
}

