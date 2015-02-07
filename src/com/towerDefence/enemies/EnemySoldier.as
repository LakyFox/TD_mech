package com.towerDefence.enemies {
	import com.framework.math.Amath;
	import com.framework.math.Avector;
	import com.towerDefence.App;
	import com.towerDefence.World;
	/**
	 * Солдат
	 * @author Laky
	 */
	public class EnemySoldier extends EnemyBase {
		
		private var _calcDelay:uint = 0;
		
		public function EnemySoldier() {
			// уникальные параметры врага
			_kind = EnemyBase.KIND_SOLDIER;
			
			// создание графического образа
			_sprite = new Soldier_mc();
			_sprite.stop();
		}
		
		override public function init(posX:int, posY:int, targetX:int, targetY:int):void {
			_health = 1;
			super.init(posX, posY, targetX, targetY);
		}
		
		override public function free():void {
			if (!_isFree) {
				// возвращение юнита в кэш
				_world.cacheEnemySoldier.set(this);
				super.free();
				_isFree = true;
			}
		}
		
		override public function update(delta:Number):void {
			// если маршрут существует
			if (_isWay) {
				// обновление угловой скорости
				if (_calcDelay > 10) {
					var angle:Number = Amath.getAngle(x, y, World.toPix(_wayTarget.x), World.toPix(_wayTarget.y));
					_speed.asSpeed(_defSpeed, angle);
					_calcDelay = 0;
				}
				_calcDelay++;
				
				// двигаем юнита
				x += _speed.x * delta;
				y += _speed.y * delta;
				
				// текущее положение
				var cp:Avector = new Avector(x, y);
				// финишная точка
				var tp:Avector = new Avector(World.toPix(_wayTarget.x), World.toPix(_wayTarget.y));
				
				// переходим к новому шагу, если текущая цель достигнута
				// Внимание! Чем больше скорость движения врага, тем больше должна быть погрешность
				if (cp.equal(tp, _defSpeed / 10)) {
					// обновляем текущие координаты в клеточках
					_position.x = World.toTile(x);
					_position.y = World.toTile(y);
					
					_wayId++;
					setNextTarget();
				}
				
				if (_isAttacked) {
					if (_sprite.currentFrame == 1) {
						_sprite.stop();
						_isAttacked = false;
					}
				}
			}
		}
		
		override public function addDamage(damage:Number):void {
			_health -= damage;
			
			//враг погиб
			if (_health <= 0) {
				isDead = true;
			}
			
			// временный эффект атаки
			_sprite.gotoAndPlay(2);
			_isAttacked = true;
		}
		
	}

}