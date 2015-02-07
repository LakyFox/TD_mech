package com.towerDefence.towers {
	import com.framework.math.Avector;
	import com.towerDefence.enemies.EnemyBase;
	import com.towerDefence.interfaces.IGameObject;
	import com.towerDefence.World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * Базовый класс для башен
	 * @author Laky
	 */
	public class TowerBase extends Sprite implements IGameObject{
		
		public static const STATE_IDLE:uint = 1;
		public static const STATE_ATTACK:uint = 2;
		
		// ссылка на игровой мир
		protected var _world:World = World.getInstance();
		// гуи тела башни
		protected var _towerBody:MovieClip;
		// гуи пушки башни
		protected var _towerHead:MovieClip;
		// позиция башни в тайлах
		protected var _tilePos:Avector = new Avector();
		// текущее состояние башни
		protected var _state:uint = STATE_IDLE;
		
		// интервал для задержки между проверками на приближение врагов
		protected var _idleDelay:int = 0;
		// радиус атаки башни
		protected var _attackRadius:Number = 100;
		// интервал между выстрелами
		protected var _attackInterval:Number = 8;
		// наносимый урон одним выстрелом
		protected var _attackDamage:Number = 0.2;
		// скорость пули
		protected var _bulletSpeed:Number = 100;
		// указатель на атакуемого юнита
		protected var _enemyTarget:EnemyBase;
		// свободна?
		protected var _isFree:Boolean = true;
		
		public function TowerBase() {
			
		}
		
		public function init(tileX:int, tileY:int):void {
			_isFree = false;
			
			if (_towerBody && _towerHead) {
				addChild(_towerBody);
				addChild(_towerHead);
			}
			
			// запоминание положения в тайлах
			_tilePos.set(tileX, tileY);
			
			// установление гуи башни
			x = World.toPix(tileX);
			y = World.toPix(tileY);
			
			// добавление башни в игру
			_world.towers.add(this);
			_world.addChild(this);
		}
		
		public function update(delta:Number):void {
			// пока пусто
		}
		
		public function free ():void {
			// удаление тела
			if (_towerBody && contains(_towerBody)) {
				removeChild(_towerBody);
			}
			
			// удаление башни
			if (_towerHead && contains(_towerHead)) {
				removeChild(_towerHead);
			}
			
			// удаление башни из игры
			_world.towers.remove(this);
		}
		
	}

}