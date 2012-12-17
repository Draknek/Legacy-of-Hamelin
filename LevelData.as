package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import com.adobe.crypto.*;
	
	public class LevelData
	{
		public static const VERSION:String = "A";
		
		public var tiles:Tilemap;
		
		public function LevelData (data:String = '')
		{
			fromString(data);
		}
		
		public function fromString (data:String):void
		{
			if (! tiles) {
				tiles = new Tilemap(Editor.EditTilesGfx, 320, 240, Main.TW, Main.TW);
			}
			
			if (data.length == 0) return;
			
			var version:String = data.charAt(0);
			
			data = data.substring(1);
			
			var i:int;
			var j:int;
			var tile:uint;
			var bytes:ByteArray;
			
			bytes = Base64.decode(data);
			
			bytes.uncompress();
			
			for (i = 0; i < tiles.columns; i++) {
				for (j = 0; j < tiles.rows; j++) {
					tile = bytes.readByte();
					
					tiles.setTile(i, j, tile);
				}
			}
		}
		
		public function toString ():String
		{
			var i:int;
			var j:int;
			var tile:uint;
			var bytes:ByteArray = new ByteArray;
			
			for (i = 0; i < tiles.columns; i++) {
				for (j = 0; j < tiles.rows; j++) {
					tile = tiles.getTile(i, j);
					
					bytes.writeByte(tile);
				}
			}
			
			bytes.compress();
			
			return VERSION + Base64.encode(bytes);
		}
	}
}

