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
	public class AlbumVO extends EventDispatcher
	{
		public var name:String;
		public var href:String;
		
		public var favoriting:FavoriteVO;
		
		public function AlbumVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject)
		}
		
		private function parseJSON(object:Object):void
		{
			this.name = object.name;
			this.href = object.href;
			this.favoriting = new FavoriteVO(object.favoriting);
		}
		
		override public function toString():String
		{
			return "[AlbumVO "+this.name+"]";
		}
	}
}