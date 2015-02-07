package com.towerDefence.editor {
	import com.towerDefence.World;
	/**
	 * ...
	 * @author Laky
	 */
	public class Brush {
		
		// вкл/выкл рисование
		public var drawMode:Boolean = false;
		// вид ячейки в кисточке
		public var kind:int = World.STATE_CELL_BUSY;
		public var tileX:int = -1;
		public var tileY:int = -1;
		
		public function Brush() {
			
		}
		
	}

}