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
				var rat:Rat;
				if (! Level(world).stealingChildren) {
					var allDead:Boolean = true;
					
					for each (rat in Level(world).rats) {
						if (rat.active) {
							allDead = false;
							break;
						}
					}
					
					if (allDead) {
						hasSomethingToSay = true;
						
						exclamation = new Entity;
						exclamation.x = x;
						exclamation.y = y - Main.TW;
						exclamation.layer = -1000;
						exclamation.graphic = new Stamp(ExclamationGfx);
						
						world.add(exclamation);
					}
				}
				if (! Level(world).killingRats) {
					var allInSewers:Boolean = true;
					
					for each (rat in Level(world).rats) {
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
				exclamation = null;
				hasSomethingToSay = false;
				
				if (Level(world).killingRats) {
					Level(world).stealingChildren = true;
					for each (var child:Child in Level(world).children) {
						child.brainwash();
					}
				} else {
					Level(world).killingRats = true;
				}
			}
		}
	}
}