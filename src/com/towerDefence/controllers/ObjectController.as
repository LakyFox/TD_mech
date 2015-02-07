package com.towerDefence.controllers {
	import com.towerDefence.interfaces.IGameObject;
	import com.towerDefence.World;
	import flash.display.DisplayObject;
	/**
	 * Контроллер объектов
	 * @author Laky
	 */
	public class ObjectController extends Object{
		
		public var objects:Vector.<IGameObject>;
		private var _world:World;
		
		public function ObjectController():void {
			objects = new Vector.<IGameObject>();
			_world = World.getInstance();
		}
		
		/**
		 * Добавление объекта в контроллер
		 * @param	obj
		 */
		public function add(obj:IGameObject):void {
			objects[objects.length] = obj;
			_world.addChild(obj as DisplayObject);
		}
		
		/**
		 * Удаление объекта из контроллера
		 * @param	obj
		 */
		public function remove(obj:IGameObject):void {
			for (var i:int = 0; i < objects.length; i++) {
				if (objects[i] == obj) {
					_world.removeChild(obj as DisplayObject);
					objects[i] = null;
					objects.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Удаление всех объектов из мира
		 */
		public function clear():void {
			while (objects.length > 0) {
				objects[0].free();
			}
		}
		
		/**
		 * Процесс всех объектов в контроллере
		 * @param	delta
		 */
		public function update(delta:Number):void {
			var n:int = objects.length - 1;
			for (var i:int = n; i >= 0; i--) {
				objects[i].update(delta);
			}
		}
		
	}

}