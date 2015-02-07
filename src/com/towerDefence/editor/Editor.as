package com.towerDefence.editor {
	import com.towerDefence.App;
	import com.towerDefence.levels.LevelBase;
	import com.towerDefence.levels.LevelManager;
	import com.towerDefence.World;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * Редактор уровней
	 * @author Laky
	 */
	public class Editor extends Sprite{
		
		private var _toolbar:Toolbar;
		private var _tbIsShow:Boolean;
		
		private var _gameWorld:World;
		private var _levelManager:LevelManager;
		private var _currentLevel:LevelBase;
		private var _brush:Brush = new Brush();
		
		public function Editor() {
			trace("Editor initialized!");
			
			if (stage) 
				init();
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// создаём игровой мир
			_gameWorld = new World();
			_gameWorld.editorMode = true;
			addChild(_gameWorld);
			_gameWorld.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_gameWorld.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			// создание тулбара
			_toolbar = new Toolbar();
			_toolbar.x = App.SCREEN_WIDTH + _toolbar.width / 2 - 10;
			_toolbar.y = App.SCREEN_HEIGHT_DIV;
			_toolbar.addEventListener(MouseEvent.CLICK, toolbarClickHandler);
			addChild(_toolbar);
			
			_toolbar.busyBtn.addEventListener(MouseEvent.CLICK, busyBtnHandler);
			_toolbar.buildOnlyBtn.addEventListener(MouseEvent.CLICK, buidOnlyBtnHandler);
			_toolbar.startPointBtn.addEventListener(MouseEvent.CLICK, startPtBtnHandler);
			_toolbar.finishPointBtn.addEventListener(MouseEvent.CLICK, finishPtBtnHandler);
			_toolbar.btnSave.addEventListener(MouseEvent.CLICK, saveClickHandler);
			_toolbar.btnClear.addEventListener(MouseEvent.CLICK, clearClickHandler);
			_toolbar.btnTest.addEventListener(MouseEvent.CLICK, testClickHandler);
			
			// создание менеджера уровней
			_levelManager = new LevelManager();
			// загрузка первого уровня
			_currentLevel = _levelManager.getLevel(1);
			_currentLevel.load();
			
			// обработчик мыши
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function testClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			_gameWorld.newEnemy();
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			_brush.drawMode = false;
			_brush.tileX = -1;
			_brush.tileY = -1;
		}
		
		private function mouseDownHandler(e:MouseEvent):void {
			_brush.drawMode = true;
			_gameWorld.applyBrush(_brush);
		}
		
		private function toolbarClickHandler(e:MouseEvent):void {
			if (_tbIsShow) {
				_toolbar.x = App.SCREEN_WIDTH + _toolbar.width / 2 - 10;
				_tbIsShow = false;
			} else {
				_toolbar.x = App.SCREEN_WIDTH - _toolbar.width / 2;
				_tbIsShow = true;
			}
		}
		
		private function clearClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			_gameWorld.clearMapMask();
			_gameWorld.updateDebugGrid();
		}
		
		private function saveClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			exportToOutput();
		}
		
		private function finishPtBtnHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			_brush.kind = World.STATE_CELL_FINISH_POINT;
		}
		
		private function startPtBtnHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			_brush.kind = World.STATE_CELL_START_POINT;
		}
		
		private function buidOnlyBtnHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			_brush.kind = World.STATE_CELL_BUILD_ONLY;
		}
		
		private function busyBtnHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			
			_brush.kind = World.STATE_CELL_BUSY;
		}
		
		private function exportToOutput():void {
			var mapMask:Array = _gameWorld.mapMask;
			var mapWidth:int = mapMask[0].length;
			var mapHeight:int = mapMask.length;
			var line:String = "";
			
			for (var ay:int = 0; ay < mapHeight; ay++) {
				for (var ax:int = 0; ax < mapWidth; ax++) {
					// для последней ячейки в строчке не ставим запятую
					if (ax == mapWidth - 1)
						line += mapMask[ay][ax].toString();
					else
						line += mapMask[ay][ax].toString() + ", ";
				}
				
				// выводим маску проходимости в формате кода
				// инициализации нового двумерного массива
				
				if (ay == 0)	// первая строка
					trace("_mapMask = [[", line + "], ");
				else if (ay == mapHeight - 1)	// последняя строка
					trace("[", line + "]];");
				else	// промежуточные строки
					trace("[", line + "],");
					
				line = "";
			}
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			_gameWorld.updateMousePosition(e.stageX, e.stageY);
			
			if (_brush.drawMode) {
				_gameWorld.applyBrush(_brush);
			}
		}
		
	}

}