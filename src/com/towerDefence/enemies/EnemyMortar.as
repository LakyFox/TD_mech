package com.towerDefence.enemies {
	import com.towerDefence.App;
	/**
	 * Мортира
	 * @author Laky
	 */
	public class EnemyMortar extends EnemyBase {
		
		public function EnemyMortar() {
			
		}
		
		override public function init():void {
			// уникальные параметры врага
			_kind = EnemyBase.KIND_MORTAR;
			_health = 300;
			_speedX = 60;
			_speedY = 60;
			
			// создание графического образа
			_sprite = new Mortar_mc();
			
			super.init();
		}
		
		override public function update(delta:Number):void {
			super.update(delta);
			
			// временный код движения объекта,
			// демонстрирующий работу класса
			x += _speedX * delta;
			y += _speedY * delta;
			
			// инвертируем скорость движения врага,
			// если он достиг границ экрана
			if (x >= App.SCREEN_WIDTH || x <= 0) {
				_speedX *= -1;
			}
			if (y >= App.SCREEN_HEIGHT || y <= 0) {
				_speedY *= -1;
			}
		}
		
	}

}