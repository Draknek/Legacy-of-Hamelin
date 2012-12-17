package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Mayor extends Entity
	{
		[Embed(source="images/tiles.png")]
		public static const Gfx: Class;
		[Embed(source="images/exclamation.png")]
		public static const ExclamationGfx: Class;
		
		public var sprite:Spritemap;
		
		public var hasSomethingToSay:Boolean = false;
		
		public var exclamation:Entity;
		
		public function Mayor (_x:Number, _y:Number)
		{
			x = _x;
			y = _y;
			
			type = "solid";
			
			layer = -y;
			
			setHitbox(Main.TW, Main.TW);
			
			sprite = new Spritemap(Gfx, 16, 16);
			
			sprite.frame = 3;
			
			graphic = sprite;
		}
		
		public function postUpdate ():void
		{
			if (! hasSomethingToSay) {
				if (! Level(world).killingRats) {
					var allInSewers:Boolean = true;
					
					for each (var rat:Rat in Level(world).rats) {
						if (rat.type == "rat") {
							allInSewers = false
							break;
						}
					}
					
					if (allInSewers) {
						hasSomethingToSay = true;
						
						exclamation = new Entity;
						exclamation.x = x;
						exclamation.y = y - Main.TW;
						exclamation.layer = -1000;
						exclamation.graphic = new Stamp(ExclamationGfx);
						
						world.add(exclamation);
					}
				}
			}
		}
		
		public function speak ():void
		{
			if (exclamation) {
				world.remove(exclamation);
				Level(world).killingRats = true;
				hasSomethingToSay = false;
			}
		}
	}
}