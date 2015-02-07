package com.towerDefence {
	import com.towerDefence.levels.LevelBase;
	import com.towerDefence.levels.LevelManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * Игра
	 * @author Laky
	 */
	public class Game extends Sprite{
		
		private var _gameWorld:World;
		private var _levelManager:LevelManager;
		private var _currentLevel:LevelBase;
		
		public function Game() {
			trace("Game initialized!");
			
			if (stage) 
				init();
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			// создаём игровой мир
			_gameWorld = new World();
			addChild(_gameWorld);
			
			// создание менеджера уровней
			_levelManager = new LevelManager();
			// загрузка первого уровня
			_currentLevel = _levelManager.getLevel(2);
			_currentLevel.load();
			
			// обработчик мыши и клавиш
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function mouseClickHandler(e:MouseEvent):void {
			_gameWorld.buildTower();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			_gameWorld.newEnemy();
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			_gameWorld.updateMousePosition(e.stageX, e.stageY);
		}
		
	}

}