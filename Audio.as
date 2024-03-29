package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.SharedObject;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import net.flashpunk.utils.Key;
	import net.flashpunk.*;
	
	import flash.media.*;
	import flash.utils.*;
	
	public class Audio
	{
		[Embed(source="audio/flute.mp3")]
		public static var NoteSfx:Class;
		
		private static var _mute:Boolean = false;
		private static var so:SharedObject;
		private static var menuItem:ContextMenuItem;
		
		public static function init (o:InteractiveObject):void
		{
			// Setup
			
			so = SharedObject.getLocal("draknek/hamelin/audio");
			
			_mute = so.data.mute;
			
			addContextMenu(o);
			
			if (o.stage) {
				addKeyListener(o.stage);
			} else {
				o.addEventListener(Event.ADDED_TO_STAGE, stageAdd);
			}
		}
		
		private static var prev:Sfx;
		private static var prevN:int;
		
		private static var sounds:Array = [];
		private static var tweens:Array = [];
		
		public static function playNote () : void
		{
			if (prev && prev.playing) {
				if (! tweens[prevN] || ! tweens[prevN].active) {
					tweens[prevN] = FP.tween(prev, {volume: 0}, 15);
				}
			}
			
			if (! mute)
			{
				var i : int = prevN = (Math.random() * 6);
				
				if (sounds[i]) {
					prev = sounds[i];
				} else {
					prev = sounds[i] = new Sfx(NoteSfx);
				}
				
				if (tweens[prevN] && tweens[prevN].active) {
					tweens[prevN].cancel();
				}
				
				prev.play(1, 0, i * 2000);
				
				var myPrev:Sfx = prev;
				
				FP.alarm(60, function ():void {
					if (! prev || prev != myPrev) return;
					tweens[prevN] = FP.tween(prev, {volume: 0}, 30);
					prev = null;
				});
			}
		}
		
		// Getter and setter for mute property
		
		public static function get mute (): Boolean { return _mute; }
		
		public static function set mute (newValue:Boolean): void
		{
			if (_mute == newValue) return;
			
			_mute = newValue;
			
			menuItem.caption = _mute ? "Unmute" : "Mute";
			
			so.data.mute = _mute;
			so.flush();
		}
		
		// Implementation details
		
		private static function stageAdd (e:Event):void
		{
			addKeyListener(e.target.stage);
		}
		
		private static function addContextMenu (o:InteractiveObject):void
		{
			//if (Main.touchscreen) return;
			
			var menu:ContextMenu = o.contextMenu || new ContextMenu;
			
			menu.hideBuiltInItems();
			
			menuItem = new ContextMenuItem(_mute ? "Unmute" : "Mute");
			
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuListener);
			
			menu.customItems.push(menuItem);
			
			o.contextMenu = menu;
		}
		
		private static function addKeyListener (stage:Stage):void
		{
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
		}
		
		private static function keyListener (e:KeyboardEvent):void
		{
			if (e.keyCode == Key.M) {
				mute = ! mute;
			}
		}
		
		private static function menuListener (e:ContextMenuEvent):void
		{
			mute = ! mute;
		}
	}
}

