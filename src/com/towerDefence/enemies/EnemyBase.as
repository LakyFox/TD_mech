package com.towerDefence.enemies {
	import com.framework.math.Amath;
	import com.framework.math.Avector;
	import com.framework.PathFinder;
	import com.towerDefence.interfaces.IGameObject;
	import com.towerDefence.World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * Базовый класс врага
	 * @author Laky
	 */
	public class EnemyBase extends Sprite implements IGameObject{
		
		public static const KIND_NONE:int = -1;
		public static const KIND_SOLDIER:int = 0;
		public static const KIND_MORTAR:int = 1;
		
		// ссылка на игровой мир
		internal var _world:World;
		// разновидность врага
		internal var _kind:int = KIND_NONE;
		// здоровье врага
		internal var _health:Number = 0;
		// визуальное представление врага
		internal var _sprite:MovieClip;
		
		// координаты текущей ячейки врага
		private var _cellPosX:int;
		private var _cellPosY:int;
		
		protected var _defSpeed:Number = 100;
		protected var _speed:Avector = new Avector();
		protected var _position:Point;	// текущее положение врага
		protected var _target:Point;	// цель, куда должен прийти враг
		protected var _way:Array;	// маршрут врага
		protected var _isWay:Boolean = false;	// определяет существование маршрута
		protected var _wayId:int = 0;	// текущий индекс маршрута
		protected var _wayTarget:Point;	// текущая цель
		protected var _isAttacked:Boolean;	// под атакой
		protected var _isFree:Boolean = true;	// свободен
		
		public var isDead:Boolean;
		
		public function EnemyBase() {
			_world = World.getInstance();
		}
		
		/**
		 * Инициализация
		 */
		public function init(tileX:int, tileY:int, targetTileX:int, targetTileY:int):void { 
			isDead = false;	// воскрешение юнита
			_isFree = false;	// юнит используется
			_speed.set(0, 0);	// обнуление скорости движения
			
			if (_sprite) {
				addChild(_sprite);
			}
			
			// запоминаем положение и цель врага
			_position = new Point(tileX, tileY);
			_target = new Point(targetTileX, targetTileY);
			
			// установка положения врага в пикселях
			x = World.toPix(tileX);
			y = World.toPix(tileY);
			
			// устанавливаем врага на карте
			_world.enemies.add(this);
			_world.addChild(this);
			
			// ищем маршрут
			var pathFinder:PathFinder = new PathFinder(_world.mapMask);
			pathFinder.freeCell = World.STATE_CELL_FREE;
			_way = pathFinder.findWay(_position, _target);
			if (_way.length == 0) {
				trace("EnemyBase::init() - путь не найден!");
			} else {
				// путь найден
				_isWay = true;
				_wayId = 0;	// текущий шаг
				setNextTarget();	// текущая цель
			}
		}
		
		protected function setNextTarget():void {
			if (_wayId == _way.length) {
				// весь маршрут пройден
				_isWay = false;
			} else {
				// новая цель
				_wayTarget = _way[_wayId];
				
				// расчёт угла между текущими координатами и следующей точкой
				var angle:Number = Amath.getAngle(x, y, World.toPix(_wayTarget.x), World.toPix(_wayTarget.y));
				
				// установка новой скорости
				_speed.asSpeed(_defSpeed, angle);
				
				// разворот спрайта
				_sprite.rotation = Amath.toDegrees(angle);
			}
		}
		
		/**
		 * Удаление врага
		 */
		public function free():void {
			if (_sprite && contains(_sprite)) {
				removeChild(_sprite);
			}
			
			_world.enemies.remove(this);
		}
		
		/**
		 * Обновление врага, здесь будут производится все расчёты
		 * @param	delta
		 */
		public function update(delta:Number):void {
			//_cellPosX = int(x	/ World.MAP_CELL_SIZE);
			//_cellPosY = int(y	/ World.MAP_CELL_SIZE);
		}
		
		/**
		 * расчёт нового положения врага
		 * @param	cellX
		 * @param	cellY
		 */
		public function setToCell(cellX:int, cellY:int):void {
			x = World.MAP_CELL_HALF + cellX * World.MAP_CELL_SIZE;
			y = World.MAP_CELL_HALF + cellY * World.MAP_CELL_SIZE;
		}
		
		public function get kind():int {
			return _kind;
		}
		
		public function addDamage(damage:Number):void {
			
		}
		
	}

}