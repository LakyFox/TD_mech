package com.towerDefence.editor {
	import com.towerDefence.World;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Панель инстументов
	 * @author Laky
	 */
	public class Toolbar extends Sprite {
		
		private var _itemsCont:Sprite;
		private var _busyBtn:Busy_btn;
		private var _buildOnlyBtn:BuildOnly_btn;
		private var _startPointBtn:StartPoint_btn;
		private var _finishPointBtn:FinishPoint_btn;
		private var _btnSave:Save_btn;
		private var _clearBtn:Clear_btn;
		private var _testBtn:Test_btn;
		
		public function Toolbar() {
			_itemsCont = new Sprite();
			addChild(_itemsCont);
			
			// создание тулбара
			var toolbar:Toolbar_mc = new Toolbar_mc();
			_itemsCont.addChild(toolbar);
			
			// создание кнопки "занято"
			_busyBtn = new Busy_btn();
			_busyBtn.x = _busyBtn.width * 2 - toolbar.width / 2;
			_busyBtn.y = _busyBtn.height * 2 - toolbar.height / 2;
			_itemsCont.addChild(_busyBtn);
			
			// создание кнопки "только для зданий"
			_buildOnlyBtn = new BuildOnly_btn();
			_buildOnlyBtn.x = _busyBtn.x + _buildOnlyBtn.width * 2;
			_buildOnlyBtn.y = _busyBtn.y;
			_itemsCont.addChild(_buildOnlyBtn);
			
			// создание кнопки "стартовая точка волны"
			_startPointBtn = new StartPoint_btn();
			_startPointBtn.x = _buildOnlyBtn.x + _startPointBtn.width * 2;
			_startPointBtn.y = _buildOnlyBtn.y;
			_itemsCont.addChild(_startPointBtn);
			
			// создание кнопки "финишная точка волны"
			_finishPointBtn = new FinishPoint_btn();
			_finishPointBtn.x = _startPointBtn.x + _finishPointBtn.width * 2;
			_finishPointBtn.y = _startPointBtn.y;
			_itemsCont.addChild(_finishPointBtn);
			
			// создание кнопки сохранить
			_btnSave = new Save_btn();
			_btnSave.x = (-_btnSave.width / 2) * 1.1;
			_btnSave.y = toolbar.height / 2 - _btnSave.height;
			addChild(_btnSave);
			
			// создание кнопки очистить
			_clearBtn = new Clear_btn();
			_clearBtn.x = (_clearBtn.width / 2) * 1.1;
			_clearBtn.y = _btnSave.y;
			addChild(_clearBtn);
			
			// создание кнопки для теста
			_testBtn = new Test_btn();
			_testBtn.y = _btnSave.y - _testBtn.height * 1.5;
			addChild(_testBtn);
			
			addEventListener(Event.REMOVED_FROM_STAGE, destructor);
		}
		
		public function get busyBtn():Busy_btn {
			return _busyBtn;
		}
		
		public function get buildOnlyBtn():BuildOnly_btn {
			return _buildOnlyBtn;
		}
		
		public function get startPointBtn():StartPoint_btn {
			return _startPointBtn;
		}
		
		public function get finishPointBtn():FinishPoint_btn {
			return _finishPointBtn;
		}
		
		public function get btnSave():Save_btn {
			return _btnSave;
		}
		
		public function get btnClear():Clear_btn {
			return _clearBtn;
		}
		
		public function get btnTest():Test_btn {
			return _testBtn;
		}
		
		private function destructor(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, destructor);
			
			while (_itemsCont.numChildren > 0)
				_itemsCont.removeChildAt(0);
			
			removeChild(_itemsCont);
			_itemsCont = null;
			
			_busyBtn = null;
			_buildOnlyBtn = null;
			_startPointBtn = null;
			_finishPointBtn = null;
			_btnSave = null;
			_clearBtn = null;
		}
		
	}

}