package com.towerDefence.levels {
	/**
	 * Менеджер уровней
	 * @author Laky
	 */
	public class LevelManager {
		
		public static const TOTAL_LEVELS:int = 2;
		
		private var _completed:int = 1;
		
		public function LevelManager() {
			
		}
		
		public function getLevel(levelId:int):LevelBase {
			if (levelId < 0 || levelId > TOTAL_LEVELS) {
				trace("LevelManager::getLevel() - уровня ", levelId, " не существует!");
				return null;
			}
			
			switch(levelId) {
				case 1:
					return new Level1();
				break;
				
				case 2:
					return new Level2();
				break;
				
				default:
					return null;
				break;
			}
		}
		
	}

}