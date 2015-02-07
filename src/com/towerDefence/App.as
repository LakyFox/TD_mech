package com.towerDefence {
	import com.framework.SWFProfiler;
	import com.towerDefence.editor.Editor;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * Основной класс приложения
	 * @author Laky
	 */
	public class App extends Sprite{
		
		public static const APP_VERSION:String = "TowerDefence 0.1 - Nov 9, 2013";
		
		// размер документа по ширине и высоте
		public static const SCREEN_WIDTH:int = 640;
		public static const SCREEN_HEIGHT:int = 480;
		
		// середина документа
		public static const SCREEN_WIDTH_DIV:int = 320;
		public static const SCREEN_HEIGHT_DIV:int = 240;
		
		// vars
		private var _game:Game;
		private var _editor:Editor;
		private var _btnEditor:Editor_btn;
		private var _btnGame:Game_btn;
		
		public function App() {
			trace(APP_VERSION);
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		public function init (event:Event = null):void {
			// профайлер
			SWFProfiler.init(stage, this);
			
			// кнопка Game
			_btnGame = new Game_btn();
			_btnGame.x = SCREEN_WIDTH_DIV;
			_btnGame.y = SCREEN_HEIGHT_DIV - _btnGame.height;
			_btnGame.addEventListener(MouseEvent.CLICK, gameClickHandler);
			addChild(_btnGame);
			
			// кнопка Editor
			_btnEditor = new Editor_btn();
			_btnEditor.x = SCREEN_WIDTH_DIV;
			_btnEditor.y = SCREEN_HEIGHT_DIV + _btnEditor.height;
			_btnEditor.addEventListener(MouseEvent.CLICK, editorClickHandler);
			addChild(_btnEditor);
		}
		
		private function editorClickHandler(e:MouseEvent):void {
			_editor = new Editor();
			addChild(_editor);
			free();
		}
		
		private function gameClickHandler(e:MouseEvent):void {
			_game = new Game();
			addChild(_game);
			free();
		}
		
		private function free():void {
			removeChild(_btnGame);
			removeChild(_btnEditor);
			
			_btnGame.removeEventListener(MouseEvent.CLICK, gameClickHandler);
			_btnEditor.removeEventListener(MouseEvent.CLICK, editorClickHandler);
			
			_btnGame = null;
			_btnEditor = null;
		}
		
	}

}