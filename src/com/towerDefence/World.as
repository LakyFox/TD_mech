package com.towerDefence {
	import com.framework.math.Amath;
	import com.framework.math.Avector;
	import com.framework.SimpleCache;
	import com.towerDefence.controllers.ObjectController;
	import com.towerDefence.editor.Brush;
	import com.towerDefence.enemies.EnemyBase;
	import com.towerDefence.enemies.EnemyMortar;
	import com.towerDefence.enemies.EnemySoldier;
	import com.towerDefence.towers.cannon.GunBullet;
	import com.towerDefence.towers.cannon.GunTower;
	import com.towerDefence.towers.TowerBase;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	/**
	 * Игровой мир
	 * @author Laky
	 */
	public class World extends Sprite{
		
		public static const MAP_WIDTH_MAX:int = 20;
		public static const MAP_HEIGHT_MAX:int = 15;
		public static const MAP_CELL_SIZE:int = 32;
		public static const MAP_CELL_HALF:int = 16;
		
		public static const STATE_CELL_FREE:int = 1;
		public static const STATE_CELL_BUSY:int = 2;
		public static const STATE_CELL_BUILD_ONLY:int = 3;
		public static const STATE_CELL_START_POINT:int = 4;
		public static const STATE_CELL_FINISH_POINT:int = 5;
		
		private static var _instance:World;
		
		private var _mapMask:Array;
		private var _debugGrid:Bitmap;
		private var _currentCell:CurrentCell_mc;
		private var _deltaTime:Number = 0;	// текущее дельта время
		private var _lastTick:int = 0;	// последний тик таймера
		private var _maxDeltaTime:Number = 0.04;
		
		private var _isEditor:Boolean;
		private var _startPoints:Array = [];
		private var _finishPoints:Array = [];
		
		public var towers:ObjectController;
		public var enemies:ObjectController;
		public var bullets:ObjectController;
		
		// кэш
		public var cacheEnemySoldier:SimpleCache
		public var cacheGunTower:SimpleCache
		public var cacheGunBullet:SimpleCache
		
		// текущее положение курсора
		public var mousePosX:int = 0;
		public var mousePosY:int = 0;
		// текущая ячейка, над которой находится курсор
		public var cellPosX:int = 0;
		public var cellPosY:int = 0;
		
		public function World() {
			trace("World initialized!");
			
			if (_instance != null) {
				throw("Error: the world is already exist. You must use World.getInstance();");
			}
			_instance = this;
			
			towers = new ObjectController();
			enemies = new ObjectController();
			bullets = new ObjectController();
			
			// инициализация кэша
			cacheEnemySoldier = new SimpleCache(EnemySoldier, 50);
			cacheGunTower = new SimpleCache(GunTower, 20);
			cacheGunBullet = new SimpleCache(GunBullet, 50);
			
			clearMapMask(); // создаём маску
			
			// устанавливаем препятствия
			setCellState(1, 1, STATE_CELL_BUSY);
			setCellState(2, 1, STATE_CELL_BUILD_ONLY);
			
			_debugGrid = new Bitmap();
			addChild(_debugGrid);
			
			updateDebugGrid(); // создаём сетку
			
			_currentCell = new CurrentCell_mc();
			addChild(_currentCell);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			/************************ тестовый полигон *************************/
			//var soldier:EnemySoldier = new EnemySoldier();
			//soldier.init();
			//var mortar:EnemyMortar = new EnemyMortar();
			//mortar.init();
			
			//var tower:GunTower = new GunTower();
			//tower.init(2, 1);
			//tower = new GunTower();
			//tower.init(2, 3);
		}
		
		public function newEnemy():void {
			// создание тестового врага
			var soldier:EnemySoldier = cacheEnemySoldier.get() as EnemySoldier;
			
			// выбор случайной стартовой и финишной точек
			var startPos:Avector = _startPoints[Amath.random(1, _startPoints.length) - 1];
			var finishPos:Avector = _finishPoints[Amath.random(1, _finishPoints.length) - 1];
			
			// инициализация юнита с выбранными точками
			soldier.init(startPos.x, startPos.y, finishPos.x, finishPos.y);
		}
		
		public function buildTower():void {
			if (getCellState(cellPosX, cellPosY) != STATE_CELL_BUSY) {
				var tower:GunTower = cacheGunTower.get() as GunTower;
				tower.init(cellPosX, cellPosY);
				setCellState(cellPosX, cellPosY, STATE_CELL_BUSY);
				updateDebugGrid();
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			if (getCellState(cellPosX, cellPosY) == STATE_CELL_BUSY) {
				setCellState(cellPosX, cellPosY, STATE_CELL_FREE);
			} else {
				setCellState(cellPosX, cellPosY, STATE_CELL_BUSY);
			}
			
			updateDebugGrid();
		}
		
		private function enterFrameHandler(e:Event):void {
			// расчёт дельта времени
			_deltaTime = (getTimer() - _lastTick) / 1000;
			if (_deltaTime > _maxDeltaTime)
				_deltaTime = _maxDeltaTime;
			
			enemies.update(_deltaTime);
			towers.update(_deltaTime);
			bullets.update(_deltaTime);
			
			_lastTick = getTimer();
		}
		
		/**
		 * Дебажная сетка
		 */
		public function updateDebugGrid ():void {
			var cell:DebugCell_mc = new DebugCell_mc();	// текущая ячейка
			
			// рстровый холст для рисования сетки
			var bmpData:BitmapData = new BitmapData(
				MAP_CELL_SIZE * MAP_WIDTH_MAX, 
				MAP_CELL_SIZE * MAP_HEIGHT_MAX, 
				true, 
				0x00000000);
			
			// начальное положение текущей ячейки по высоте/ширине
			var matrix:Matrix = new Matrix();
			matrix.tx = MAP_CELL_HALF;
			matrix.ty = MAP_CELL_HALF;
			
			// двигаемся по высоте карты
			for (var ay:int = 0; ay < MAP_HEIGHT_MAX; ay++) {
				// двигаемся по ширине карты
				for (var ax:int = 0; ax < MAP_WIDTH_MAX; ax++) {
					// переключаем состояние ячейки
					cell.gotoAndStop(getCellState(ax, ay));
					
					// рисуем текущую ячейку
					bmpData.draw(cell, matrix);
					
					// меняем положение текущей ячейки по ширине
					matrix.tx += MAP_CELL_SIZE;
				}
				
				// меняем положение текущей ячейки по высоте
				matrix.ty += MAP_CELL_SIZE;
				// обнуляем ширину
				matrix.tx = MAP_CELL_HALF;
			}
			
			// передаём растровый холст в картинку
			_debugGrid.bitmapData = bmpData;
			cell = null;
		}
		
		/**
		 * Создание новой карты проходимости
		 */
		public function clearMapMask():void {
			_mapMask = [];
			_mapMask.length = MAP_HEIGHT_MAX;
			
			// двигаемся по высоте карты
			for (var i:int = 0; i < MAP_HEIGHT_MAX; i++) {
				_mapMask[i] = [];
				_mapMask[i].length = MAP_WIDTH_MAX;
				
				// двигаемся по ширине карты
				for (var j:int = 0; j < MAP_WIDTH_MAX; j++) {
					_mapMask[i][j] = STATE_CELL_FREE;
				}
			}
		}
		
		public function getCellState(ax:int, ay:int):int {
			// проверка на выход за переделы массива
			if (ax >= 0 && ax < MAP_WIDTH_MAX && ay >= 0 && ay < MAP_HEIGHT_MAX) {
				return _mapMask[ay][ax];
			} else {
				return STATE_CELL_BUSY;
			}
		}
		
		public function setCellState(ax:int, ay:int, state:int = STATE_CELL_FREE):void {
			// проверка на выход за переделы массива
			if (ax >= 0 && ax < MAP_WIDTH_MAX && ay >= 0 && ay < MAP_HEIGHT_MAX) {
				_mapMask[ay][ax] = state;
			}
		}
		
		public static function getInstance():World {
			return _instance != null ? _instance : new World();
		}
		
		public function updateMousePosition(mouseX:int, mouseY:int):void {
			mousePosX = mouseX;
			mousePosY = mouseY;
			
			// координаты тайла, надо которым находится курсор
			cellPosX = int(mouseX / MAP_CELL_SIZE);
			cellPosY = int(mouseY / MAP_CELL_SIZE);
			
			// подсветка текущего тайла
			_currentCell.x = MAP_CELL_HALF + cellPosX * MAP_CELL_SIZE;
			_currentCell.y = MAP_CELL_HALF + cellPosY * MAP_CELL_SIZE;
		}
		
		public function set editorMode(value:Boolean):void {
			_isEditor = value;
		}
		
		public function get mapMask():Array {
			return _mapMask;
		}
		
		public function set mapMask(value:Array):void {
			if (value != null) {
				_mapMask = value;
				preparePoints();
				updateDebugGrid();
			}
		}
		
		public static function toTile(value:Number):int {
			return int(value / MAP_CELL_SIZE);
		}
		
		public static function toPix(value:int):Number {
			return MAP_CELL_HALF + value * MAP_CELL_SIZE;
		}
		
		public function applyBrush(brush:Brush):void {
			// рисуем только если изменилось положение кисти
			if (brush.tileX != cellPosX || brush.tileY != cellPosY) {
				// если ячейка занята, то освобождаем её
				var cellState:int = getCellState(cellPosX, cellPosY);
				if (cellState != STATE_CELL_FREE && cellState == brush.kind) {
					setCellState(cellPosX, cellPosY, STATE_CELL_FREE);
				} else {
					setCellState(cellPosX, cellPosY, brush.kind);
				}
				
				brush.tileX = cellPosX;
				brush.tileY = cellPosY;
				updateDebugGrid();
			}
		}
		
		public function preparePoints():void {
			// очистка сисков
			_startPoints.length = 0;
			_finishPoints.length = 0;
			
			// перебор карты проходимости и создание новых точек
			for (var ty:int = 0; ty < _mapMask.length; ty++) {
				for (var tx:int = 0; tx < _mapMask[0].length; tx++) {
					switch(_mapMask[ty][tx]) {
						// стартовая точка
						case STATE_CELL_START_POINT:
							_startPoints.push(new Avector(tx, ty));
							if (!_isEditor)
								_mapMask[ty][tx] = STATE_CELL_FREE;
							break;
							
						// финишная точка
						case STATE_CELL_FINISH_POINT:
							_finishPoints.push(new Avector(tx, ty));
							if (!_isEditor)
								_mapMask[ty][tx] = STATE_CELL_FREE;
							break;
					}
				}
			}
		}
		
	}

}