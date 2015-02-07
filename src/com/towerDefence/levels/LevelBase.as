package com.towerDefence.levels {
	import com.towerDefence.World;
	/**
	 * Базовый класс уровня
	 * @author Laky
	 */
	public class LevelBase {
		
		protected var _world:World = World.getInstance();
		protected var _mapMask:Array;
		
		public function LevelBase() {
			
		}
		
		/**
		 * Загружает в мир маску проходимости
		 */
		public function load():void {
			_world.mapMask = _mapMask;
		}
		
	}

}