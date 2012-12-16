package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Sewer extends Entity
	{
		[Embed(source="images/sewer.png")]
		public static const Gfx: Class;
		
		public var sprite:Spritemap;
		
		public var full:Boolean = false;
		
		public function Sewer (_x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			
			type = "sewer";
			
			layer = 900;
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.add("menace", [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2], 0.05);
			
			sprite.rate = Math.random() + 1.0;
			
			graphic = sprite;
		}
		
		public function addRat ():void
		{
			full = true;
			sprite.play("menace");
		}
		
		public function removeRat ():void
		{
			full = false;
			sprite.frame = 2;
		}
	}
}