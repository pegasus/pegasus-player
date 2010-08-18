/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.model.vo
{
	import flash.events.EventDispatcher;
	/**
	* TODO: Write a meaningful description of this Class.
	*/
	[Bindable]
	public class ConfigVO extends EventDispatcher
	{
		public var feed:String = "";
		public var autoplay:Boolean = false;
		public var position:int = 0;
		public var base_url:String;
		
		override public function toString():String
		{
			return "[ConfigVO feed:" + this.feed + 
						" autoplay:" + this.autoplay + 
						" position:" + this.position + "]"; 
		}
	}
}