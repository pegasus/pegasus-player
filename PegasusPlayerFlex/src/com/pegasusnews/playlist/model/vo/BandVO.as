/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.model.vo
{
	import com.carlcalderon.arthropod.Debug;
	
	import flash.events.EventDispatcher;

	/**
	* TODO: Write a meaningful description of this Class.
	*/
	[Bindable]
	public class BandVO extends EventDispatcher
	{
		public var name:String;
		public var href:String;
		public var banner:String;
		public var next_show:EventVO;
		
		public var favoriting:FavoriteVO;
		
		public function BandVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject)
		}
		
		private function parseJSON(object:Object):void
		{
			this.name = object.name;
			this.href = object.href;
			this.banner = object.banner;
			this.next_show = new EventVO(object.next_show);
			this.favoriting = new FavoriteVO(object.favoriting);
		}
		
		override public function toString():String
		{
			return "[BandVO "+this.name+"]";
		}
	}
}