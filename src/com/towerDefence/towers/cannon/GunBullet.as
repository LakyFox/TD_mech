package com.towerDefence.towers.cannon {
	import com.towerDefence.towers.BulletBase;
	/**
	 * ...
	 * @author Laky
	 */
	public class GunBullet extends BulletBase {
		
		public function GunBullet() {
			_sprite = new GunBullet_mc();
		}
		
		override public function init(ax:int, ay:int, speed:Number, angle:Number):void {
			super.init(ax, ay, speed, angle);
		}
		
		override public function free():void {
			if (!_isFree) {
				// возвращение пули в кэш
				_world.cacheGunBullet.set(this);
				super.free();
				_isFree = true;
			}
		}
		
	}

}