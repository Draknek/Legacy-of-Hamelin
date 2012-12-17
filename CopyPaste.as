package
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	
	public class CopyPaste
	{
		/**
		 * Set this variable to whatever you want to be copied.
		 */
		public static var data:String = "";
		
		/**
		 * The function that will be called when data is pasted from the clipboard.
		 * Must have the type signature: function (String): void
		 *
		 * This function is also called on every key-input, this is unfortunately
		 * unavoidable due to an implementation detail. You probably want an early
		 * out if data.length <= 1.
		 *
		 * This function should check that the data is valid and set CopyPaste.data if so.
		 */
		public static var pasteFunction:Function;
		
		private static var textfield:TextField;
		
		private static var stage:Stage;
		
		/**
		 * Adds a TextField over the whole app. 
		 * Allows for right-click copy/paste, as well as ctrl-c/ctrl-v
		 */
		public static function init(_stage:Stage, _pasteFunction:Function):void
		{
			CopyPaste.stage = _stage;
			CopyPaste.pasteFunction = _pasteFunction;
			
			textfield = new TextField();
			textfield.addEventListener(TextEvent.TEXT_INPUT, updateFromCopyPaste);
			textfield.addEventListener(KeyboardEvent.KEY_DOWN, updateCopyPaste);
			textfield.addEventListener(KeyboardEvent.KEY_UP, updateCopyPaste);
			textfield.wordWrap = false;
			textfield.multiline = true;
			textfield.type = TextFieldType.INPUT;
			textfield.x = 0;
			textfield.y = 0;
			textfield.width = stage.stageWidth;
			textfield.height = stage.stageHeight;
			textfield.alpha = 0;
			
			stage.addChild(textfield);
			
			textfield.addEventListener(MouseEvent.CLICK, updateCopyPaste);
			
			// Catch right-click event
			textfield.contextMenu = new ContextMenu();
			textfield.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, updateCopyPaste);
			
			// Prevent mouse cursor from changing pointer when over our fullscreen textfield.
			Mouse.cursor = MouseCursor.ARROW;
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 * Called by various events: forces the textfield to contain
		 * the current string we want copied.
		 */
		private static function updateCopyPaste(e:Event = null):void
		{
			textfield.text = data;
			
			textfield.setSelection(0, textfield.text.length);
			stage.focus = textfield;
		}
		
		/**
		 * Called when the textfield contents change (on paste, as well as most keypresses).
		 */
		private static function updateFromCopyPaste(e:TextEvent):void
		{
			try {
				pasteFunction(e.text);
			} catch (error:Error) {
				trace(error);
			}
			
			textfield.text = data;
			textfield.setSelection(0, textfield.text.length);
			stage.focus = textfield;
		}
		
		private static function onResize (e:Event):void
		{
			textfield.width = stage.stageWidth;
			textfield.height = stage.stageHeight;
		}
		
	}
}
