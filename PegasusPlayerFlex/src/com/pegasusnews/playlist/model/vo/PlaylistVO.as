/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.model.vo
{
	import com.carlcalderon.arthropod.Debug;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	/**
	* Playlist Value Object
	*/
	[Bindable]
	public class PlaylistVO extends EventDispatcher
	{
		
		public var playlist_name:String;
		public var is_randomized:Boolean;
		public var session_cookie_name:String;
		public var is_authed:String;
		public var playlist_total_length:int;
		public var next_page:String;
		public var previous_page:String;
		
		public var items:ArrayCollection = new ArrayCollection();
		
		public function PlaylistVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject);
		}
		
		public function getItemAtIndex(index:int):PlaylistItemVO
		{
			if(index>items.length-1)
				index = items.length-1;
			else if(index<0)
				index = 0;	
			return this.items.getItemAt(index) as PlaylistItemVO;		
		}
		
		public function getSongAtIndex(index:int):SongVO
		{
			var item:PlaylistItemVO = this.items.getItemAt(0) as PlaylistItemVO;
			return item.song;
		}
		
		private function parseJSON(object:Object):void
		{
			Debug.log("Parsing JSON", Debug.BLUE);
			this.is_authed = object.is_authed;
			this.is_randomized = object.is_randomized;
			this.next_page = object.next_page;
			this.playlist_name = object.playlist_name;
			this.playlist_total_length = object.playlist_total_length;
			this.previous_page = object.previous_page;
			this.session_cookie_name = object.session_cookie_name;
			
			for each(var item:Object in object.items)
			{
				this.items.addItem(new PlaylistItemVO(item));
			}
			Debug.log(this.toString(),Debug.PINK);
			Debug.log("PlaylistParsed", Debug.BLUE);
		}
		
		override public function toString():String
		{
			return "[PlaylistVO "+this.playlist_name+"]";
		}
	}
}