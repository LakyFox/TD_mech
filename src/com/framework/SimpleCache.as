package com.framework {
	/**
	 * Cache
	 * @author Laky
	 */
	public class SimpleCache {
		
		protected var _targetClass:Class;
		protected var _currentIndex:int;
		protected var _instances:Array;
		
		public function SimpleCache(targetClass:Class, initialCapacity:uint) {
			_targetClass = targetClass;	// базовый класс всех объектов
			_currentIndex = initialCapacity - 1;	// индекс текущего свободного объекта
			_instances = [];	// список всех объектов
			
			// заполнение обоймы
			for (var i:int = 0; i < initialCapacity; i++) {
				_instances[i] = getNewInstance();
			}
		}
		
		protected function getNewInstance():Object {
			return new _targetClass();
		}
		
		/**
		 * Взять объект
		 */
		public function get ():Object {
			if (_currentIndex >= 0) {
				// возвращается свободный объект из кэша
				var obj:Object = _instances[_currentIndex];
				_currentIndex--;
				return obj;
			} else {
				// если обойма пуса, то экстренно создаётся новый объект
				return getNewInstance();
			}
		}
		
		/**
		 * Положить объект
		 */
		public function set (instance:Object):void {
			_currentIndex++;
			
			// если обойма переполнена
			if (_currentIndex == _instances.length) {
				// то помещается в конец массива, как новый элемент
				_instances[_instances.length] = instance;
			} else {
				// помещается в свободную ячейку массива
				_instances[_currentIndex] = instance;
			}
		}
		
	}

}