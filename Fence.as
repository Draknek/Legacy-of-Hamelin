package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	public class Fence extends Entity
	{
		[Embed(source="images/fence.png")]
		public static const Gfx: Class;
		
		public function Fence (i:int, j:int, tiles:Tilemap)
		{
			x = i * tiles.tileWidth;
			y = j * tiles.tileHeight;
			
			type = "solid";
			
			layer = -y*1000;
			
			setHitbox(Main.TW, Main.TW);
			
			var bitmap:BitmapData = new BitmapData(Main.TW+4, Main.TW*2+4, true, 0x0);
			
			var FENCE:int = 7;
			
			FP.rect.x = 0;
			FP.rect.y = Main.TW*2;
			FP.rect.width = Main.TW;
			FP.rect.height = Main.TW;
			FP.point.x = 2;
			
			var src:BitmapData = FP.getBitmap(Gfx);
			
			if (notFenceTile(i, j - 1, tiles)) {
				FP.point.y = 1;
				bitmap.copyPixels(src, FP.rect, FP.point, null, null, true);
			}
			
			if (notFenceTile(i, j + 1, tiles)) {
				FP.point.y = Main.TW + 1;
				bitmap.copyPixels(src, FP.rect, FP.point, null, null, true);
			}
			
			FP.rect.y = 0;
			FP.rect.height = Main.TW*2;
			FP.point.y = 1;
			
			if (notFenceTile(i - 1, j, tiles)) {
				FP.point.x = -5;
				bitmap.copyPixels(src, FP.rect, FP.point, null, null, true);
			}
			
			if (notFenceTile(i + 1, j, tiles)) {
				FP.point.x = -7 + Main.TW;
				bitmap.copyPixels(src, FP.rect, FP.point, null, null, true);
			}
			
			graphic = new Stamp(bitmap);
			graphic.x = -2;
			graphic.y = - Main.TW;
		}
		
		public static function notFenceTile (i:int, j:int, tiles:Tilemap):Boolean
		{
			if (i < 0 || j < 0 || i >= tiles.columns || j >= tiles.rows) return false;
			
			var tile:uint = tiles.getTile(i, j);
			
			return (tile != 7);
		}
	}
}