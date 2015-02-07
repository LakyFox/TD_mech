package com.towerDefence.interfaces {
	import flash.display.Sprite;
	
	/**
	 * Интерфейс игровых объектов
	 * @author Laky
	 */
	public interface IGameObject{
		
		function free():void;
		function update(delta:Number):void;
		
	}
	
}