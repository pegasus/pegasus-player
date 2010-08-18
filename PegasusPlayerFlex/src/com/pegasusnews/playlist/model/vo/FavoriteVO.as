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
	public class FavoriteVO extends EventDispatcher
	{
		public var is_favorited:Boolean;
		public var favorite:String;
		public var unfavorite:String;
		
		public function FavoriteVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject)
		}
		
		private function parseJSON(object:Object):void
		{
			this.is_favorited = object.is_favorited;
			this.favorite = object.favorite;
			this.unfavorite = object.unfavorite;
		}
		
		override public function toString():String
		{
			return "[FavoriteVO "+this.is_favorited+"]";
		}
	}
}