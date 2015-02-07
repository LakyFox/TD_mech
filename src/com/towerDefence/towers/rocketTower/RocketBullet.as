package com.towerDefence.towers.rocketTower {
	import com.towerDefence.towers.BulletBase;
	
	/**
	 * ...
	 * @author Laky
	 */
	public class RocketBullet extends BulletBase {
		
		public function RocketBullet() {
			_sprite = new Rocket_mc();
		}
		
		override public function init(ax:int, ay:int, speed:Number, angle:Number):void {
			super.init(ax, ay, speed, angle);
		}
		
		override public function free():void {
			if (!_isFree) {
				// вернуть в кэш
				_world.cacheGunBullet.set(this);
				super.free();
				_isFree = true;
			}
		}
		
	}

}