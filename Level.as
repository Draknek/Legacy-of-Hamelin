package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Level extends World
	{
		public var src:Tilemap;
		public var bg:Tilemap;
		
		public var levelID:int;
		
		public var rats:Array = [];
		
		public var killingRats:Boolean = false;
		
		public function Level (src:Tilemap = null, i:int = 0)
		{
			levelID = i;
			
			if (! src) {
				src = Editor.src;
			}
			
			this.src = src;
			
			bg = src.getSubMap(0, 0, src.columns, src.rows);
			addGraphic(bg, 1000);
			
			var solidMask:Grid = new Grid(FP.width, FP.height, src.tileWidth, src.tileHeight);
			var waterMask:Grid = new Grid(FP.width, FP.height, src.tileWidth, src.tileHeight);
			
			addMask(solidMask, "solid");
			addMask(waterMask, "water");
			
			for (var i:int = 0; i < src.columns; i++) {
				for (var j:int = 0; j < src.rows; j++) {
					var tile:uint = src.getTile(i, j);
					
					var x:Number = camera.x + i * src.tileWidth;
					var y:Number = camera.y + j * src.tileHeight;
					
					var e:Entity = null;
					
					switch (tile) {
						case 1:
							e = new Player(x, y);
						break;
						case 2:
							e = new Rat(x, y);
							rats.push(e);
						break;
						case 6:
							e = new Sewer(x, y);
						break;
						case 7:
							e = new Fence(i, j, src);
						break;
						case 8:
							waterMask.setTile(i, j, true);
						break;
						case 0:
						break;
						default:
							solidMask.setTile(i, j, true);
					}
					
					if (e) {
						add(e);
						bg.setTile(i, j, 0);
					}
				}
			}
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.R)) {
				FP.world = new Level(src, levelID);
				return;
			}
			
			if (Main.devMode && Input.pressed(Key.N)) {
				FP.world = new Level(null, levelID + 1);
				return;
			}
			
			if (Main.devMode && Input.pressed(Key.E)) {
				FP.world = new Editor();
				return;
			}
			
			for each (var rat:Rat in rats) {
				rat.hasMoved = false;
			}
			
			super.update();
			
			if (! killingRats) {
				var allInSewers:Boolean = true;
				
				for each (rat in rats) {
					if (rat.type == "rat") {
						allInSewers = false
						break;
					}
				}
				
				if (allInSewers) {
					killingRats = true;
				}
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

