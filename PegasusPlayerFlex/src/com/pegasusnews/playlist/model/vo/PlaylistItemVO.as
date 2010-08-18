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
	public class PlaylistItemVO extends EventDispatcher
	{
		public var song:SongVO;
		public var band:BandVO;
		public var album:AlbumVO;
		
		public function PlaylistItemVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject)
		}
		
		private function parseJSON(object:Object):void
		{
			this.song = new SongVO(object.song);
			this.band = new BandVO(object.band);
			this.album = new AlbumVO(object.album);
			//Debug.log(this.toString(),Debug.LIGHT_GREEN);
		}
		
		override public function toString():String
		{
			return "[playlistItemVO "+this.band+" "+this.album+" "+this.song+"]";
		}
	}
}