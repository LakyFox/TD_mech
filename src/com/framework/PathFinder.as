package com.framework {
	import flash.geom.Point;
	/**
	 * Алгоритм поиска пути
	 * @author Laky
	 */
	public class PathFinder {
		
		// уникальный номер воды, которым заполнятеся маска по мере заполнения
		private static const _WATER_KEY:int = 999;
		
		private var _mapMask:Array = []; // копия маски карты
		private var _mapDirs:Array = [];	// направления
		private var _mapWidth:int = 0;	// ширина карты
		private var _mapHeight:int = 0;	// высота карты
		
		private var _freeCell:int = -1;	// вид свободной ячейки
		private var _maxIterations:int = 50;	// счётчик повторов
		
		/**
		 * Коструктор
		 * @param	mapArr карта проходимости (двумерный массив)
		 */
		public function PathFinder(mapArr:Array) {
			var rowMask:Array;	// строка для карты
			var rowDirs:Array;	// строка для направлений
			
			_mapWidth = mapArr[0].length;	// ширина карты
			_mapHeight = mapArr.length;	// высота карты
			
			for (var _y:int = 0; _y < _mapHeight; _y++) {
				// новые строки
				rowMask = [];
				rowDirs = [];
				
				for (var _x:int = 0; _x < _mapWidth; _x++) {
					rowMask.push(mapArr[_y][_x]); // копируем состояние клетки
					rowDirs.push(new Point());	// создаём нулевую координату направления
					
				}
				
				_mapMask.push(rowMask);
				_mapDirs.push(rowDirs);
			}
		}
		
		/**
		 * Провекрка на выход за пределы карты
		 * @param	ax
		 * @param	ay
		 * @return
		 */
		private function inMap(ax:int, ay:int):Boolean {
			if (ax >= 0 && ax < _mapWidth && ay >=0 && ay < _mapHeight) {
				return true;
			} else {
				return false;
			}
		}
		
		private function goWater(ax:int, ay:int):void {
			// если клеточка сверху свободна
			if (inMap(ax, ay - 1) && _mapMask[ay - 1][ax] == _freeCell) {
				_mapMask[ay - 1][ax] = _WATER_KEY; // заполняем её водой
				// запоминаем из какой клетки вода пришла
				(_mapDirs[ay -1][ax] as Point).x = ax;
				(_mapDirs[ay -1][ax] as Point).y = ay;
			}
			
			// если клеточка слева свободна
			if (inMap(ax + 1, ay) && _mapMask[ay][ax + 1] == _freeCell) {
				_mapMask[ay][ax + 1] = _WATER_KEY;
				(_mapDirs[ay][ax + 1] as Point).x = ax;
				(_mapDirs[ay][ax + 1] as Point).y = ay;
			}
			
			// если клеточка снизу свободна
			if (inMap(ax, ay + 1) && _mapMask[ay + 1][ax] == _freeCell) {
				_mapMask[ay + 1][ax] = _WATER_KEY;
				(_mapDirs[ay + 1][ax] as Point).x = ax;
				(_mapDirs[ay + 1][ax] as Point).y = ay;
			}
			
			// если клеточка справа свободна
			if (inMap(ax - 1, ay) && _mapMask[ay][ax - 1] == _freeCell) {
				_mapMask[ay][ax - 1] = _WATER_KEY;
				(_mapDirs[ay][ax - 1] as Point).x = ax;
				(_mapDirs[ay][ax - 1] as Point).y = ay;
			}
		}
		
		public function findWay(start:Point, end:Point):Array /* of Point */{
			// устанавливаем точку, куда льём "воду"
			_mapMask[end.y][end.x] = _WATER_KEY;
			var counter:int = 0;	//счётчик проходов по карте
			
			// выполняем проходы по карте
			while (counter < _maxIterations) {
				// ищем путь / размазываем воду по маске проходимости
				for (var _y:int = 0; _y < _mapHeight; _y++) {
					for (var _x:int = 0; _x < _mapWidth; _x++) {
						// если в текущей ячейке вода
						if (_mapMask[_y][_x] == _WATER_KEY) {
							goWater(_x, _y); // то распространяем её в соседние ячейки
						}
					}
				}
				
				// проверяем не попала ли вода в точку финиша
				if (_mapMask[start.y][start.x] == _WATER_KEY) {
					// УРА!!! Путь найден!
					// возвращаем путь
					return getWay(start, end);
				}
				
				counter++;
			}
			
			// количество проходов исчерпано - путь не найден
			// возвращаем пустой массив
			return [];
		}
		
		private function getWay(start:Point, end:Point):Array /* of Point */{
			var way:Array = [];	// маршрут
			var p1:Point = new Point(start.x, start.y);
			var p2:Point = new Point();
			
			// добавляем в маршрут все точки, пока не дойдём до конца
			while (true) {
				// получаем новую точку из направления предыдущей
				p2.x = (_mapDirs[p1.y][p1.x] as Point).x;
				p2.y = (_mapDirs[p1.y][p1.x] as Point).y;
				
				way.push(new Point(p2.x, p2.y));	// добавляем новую точку в маршрут
				p1.x = p2.x;
				p1.y = p2.y;
				
				// проверяем, не добрались ли до конца
				if (p1.x == end.x && p1.y == end.y) {
					break;
				}
			}
			
			return way;
		}
		
		public function set freeCell(value:int):void {
			_freeCell = value;
		}
		
		public function set maxIterations(value:int):void {
			_maxIterations = value;
		}
		
	}

}