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
	public class SongVO extends EventDispatcher
	{
		public var href:String;
		public var audio:String;
		public var name:String;
		
		public var favoriting:FavoriteVO;
		
		public function SongVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject)
		}
		
		private function parseJSON(object:Object):void
		{
			this.audio = object.audio;
			this.href = object.href;
			this.name = object.name;
			this.favoriting = new FavoriteVO(object.favoriting);
		}
		
		override public function toString():String
		{
			return "[SongVO "+this.name+"]";
		}
	}
}