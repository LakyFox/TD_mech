package com.towerDefence.towers {
	import com.framework.math.Amath;
	import com.framework.math.Avector;
	import com.towerDefence.App;
	import com.towerDefence.enemies.EnemyBase;
	import com.towerDefence.interfaces.IGameObject;
	import com.towerDefence.World;
	import flash.display.Sprite;
	
	/**
	 * Базовый класс пули
	 * @author Laky
	 */
	public class BulletBase extends Sprite implements IGameObject{
		
		// урон пули
		public var damage:Number = 0.1;
		// ссылка на мир
		protected var _world:World;
		// визуальная часть
		protected var _sprite:Sprite;
		// скорость пули
		protected var _speed:Avector;
		// удалена?
		protected var _isFree:Boolean = true;
		
		public function BulletBase() {
			_world = World.getInstance();
			_speed = new Avector();
		}
		
		public function init(ax:int, ay:int, speed:Number, angle:Number):void {
			_isFree = false;
			
			// добавление спрайта пули
			if (_sprite) {
				addChild(_sprite);
			}
			
			// позиционирование пули
			this.x = ax;
			this.y = ay;
			
			// установка скорости пули
			_speed.asSpeed(speed, Amath.toRadians(angle));
			
			// добавление пули в игровой мир
			_world.bullets.add(this);
			_world.addChild(this);
		}
		
		public function update(delta:Number):void {
			this.x += _speed.x * delta;
			this.y += _speed.y * delta;
			
			//**************** проверка столкновения с врагом ****************//
			// список врагов
			var enemies:Vector.<IGameObject> = _world.enemies.objects;
			// колличество врагов
			var n:int = enemies.length;
			// текущий враг
			var enemy:EnemyBase;
			// дистанция между текущим врагом и пулей
			var dist:Number;
			
			for (var i:int = 0; i < n; i++) {
				enemy = enemies[i] as EnemyBase;
				dist = Amath.distance(this.x, this.y, enemy.x, enemy.y);
				
				// если дистанция между врагом и пулей меньше или равна 
				// сумме радиусов юнита и пули, значит они сталкиваются
				if (dist <= this.width * 0.5 + enemy.width * 0.5) {
					enemy.addDamage(damage); // нанесение урона врагу
					free();	// удаление пули
					break;
				}
			}
			//**************** проверка столкновения с врагом ****************//
			
			// проверка вылета за пределы поля
			if (this.x < 0 || this.x > App.SCREEN_WIDTH || this.y < 0 || this.y > App.SCREEN_HEIGHT) {
				free();
			}
		}
		
		public function free():void {
			if (_sprite && contains(_sprite)) {
				removeChild(_sprite);
			}
			
			_world.bullets.remove(this);
		}
		
	}

}