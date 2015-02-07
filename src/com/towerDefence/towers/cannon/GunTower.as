package com.towerDefence.towers.cannon {
	import com.framework.math.Amath;
	import com.towerDefence.enemies.EnemyBase;
	import com.towerDefence.interfaces.IGameObject;
	import com.towerDefence.towers.TowerBase;
	/**
	 * Пушка
	 * @author Laky
	 */
	public class GunTower extends TowerBase {
		
		private var _shootDelay:int;
		
		public function GunTower() {
			// индивидуальные параметры текущего вида башни
			_attackRadius = 100;
			_shootDelay = _attackInterval = 10;
			_attackDamage = 0.4;
			_bulletSpeed = 300;
			
			// графический образ
			_towerBody = new GunTowerBody_mc();
			_towerHead = new GunTowerHead_mc();
		}
		
		override public function init(tileX:int, tileY:int):void {
			super.init(tileX, tileY);
			debugDraw();
		}
		
		override public function free():void {
			if (!_isFree) {
				// возвращение юнита в кэш
				_world.cacheGunTower.set(this);
				super.free();
				_isFree = true;
			}
		}
		
		override public function update(delta:Number):void {
			switch(_state) {
				// состояние наблюдения за врагами
				case STATE_IDLE:
					if (_idleDelay >= 5) {
						// указатель на список всех врагов
						var enemies:Vector.<IGameObject> = _world.enemies.objects;
						// колличество врагов в списке
						var n:int = enemies.length;
						// текущий враг из списка
						var enemy:EnemyBase;
						
						for (var i:int = 0; i < n; i++) {
							enemy = enemies[i] as EnemyBase;
							
							// если дистанция от врага до башни меньше или равна
							// радиусу атаки башни, значит атакуем врага!
							if (Amath.distance(enemy.x, enemy.y, this.x, this.y) <= _attackRadius) {
								// установка атакуемой цели
								_enemyTarget = enemy;
								// переключение в состояние атаки
								_state = STATE_ATTACK;
								trace("Атака!!!");
								break;
							}
						}
					}
					_idleDelay++;
					break;
				
				// состояние атаки
				case STATE_ATTACK:
					if (_enemyTarget) {
						// поворот башни в сторону врага
						_towerHead.rotation = Amath.getAngleDeg(this.x, this.y, _enemyTarget.x, _enemyTarget.y);
						
						// враг убит
						if (_enemyTarget.isDead) {
							_enemyTarget.free();
							_enemyTarget = null;
							_state = STATE_IDLE;
						} else
						// враг убежал
						if (Amath.distance(_enemyTarget.x, _enemyTarget.y, this.x, this.y) > _attackRadius) {
							_enemyTarget = null;
							_state = STATE_IDLE;
							trace("Наблюдение...");
						} else {	// атака
							_shootDelay--;
							if (_shootDelay <= 0) {
								shoot();
								_shootDelay = _attackInterval;
							}
						}
					} else {
						_state = STATE_IDLE;
					}
					break;
			}
		}
		
		private function shoot():void {
			trace("Бах!");
			var bullet:GunBullet = _world.cacheGunBullet.get() as GunBullet;
			bullet.damage = _attackDamage;	// передаём урон башни в пулю
			// инициализация пули
			bullet.init(this.x, this.y, _bulletSpeed, _towerHead.rotation);
		}
		
		private function debugDraw():void {
			graphics.lineStyle(1, 0x333333, .3);
			graphics.beginFill(0x333333, .2);
			graphics.drawCircle(0, 0, _attackRadius);
			graphics.endFill();
		}
		
	}

}