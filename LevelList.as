package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	import flash.net.*;
	
	public class LevelList
	{
		public static var levels:Array = [];
		
		[Embed(source="levels.list", mimeType="application/octet-stream")]
		public static const LEVELS:Class;
		
		public static function init ():void
		{
			levels.push(null);
			
			var list:String = new LEVELS;
			
			list = list.replace(/\s+$/, ''); // trim end of string
			
			var parts:Array = list.split("\n");
			
			for each (var levelInfo:String in parts) {
				if (levelInfo.length == 0) {
					continue;
				}
				
				var data:LevelData = new LevelData(levelInfo);
				
				levels.push(data);
			}
		}
	}
}