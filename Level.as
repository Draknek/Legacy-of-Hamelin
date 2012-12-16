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
		
		public function Level (src:Tilemap = null, i:int = 0)
		{
			levelID = i;
			
			if (! src) {
				src = Editor.src;
			}
			
			this.src = src;
			
			bg = src.getSubMap(0, 0, src.columns, src.rows);
			
			addGraphic(bg, 1000);
			
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
			
			super.update();
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

