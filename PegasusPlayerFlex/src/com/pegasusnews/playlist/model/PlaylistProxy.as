/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.model
{
	import com.adobe.serialization.json.JSON;
	import com.pegasusnews.playlist.model.vo.PlaylistVO;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IStartupProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.EntityProxy;

	/**
	* TODO: Write a meaningful description of this Class.
	*/
	public class PlaylistProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "PlaylistProxy";
		public static const SRNAME:String = "SR" + NAME;

		public static const PLAYLIST_LOADED:String = "note/playlistLoaded";
		public static const PLAYLIST_FAILED:String = "note/playlistFailed";
		
		public function PlaylistProxy()
		{
			super(NAME);
		}
		
		public function load():void
		{
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var request:URLRequest = new URLRequest(configProxy.config.feed);
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load(request);
			loader.dataFormat
		}
		
		private function handleLoadComplete(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, handleLoadComplete)
			var playlistObject:Object = JSON.decode(event.target.data);
			this.data = new PlaylistVO(playlistObject);
			// call the StartupMonitorProxy for notify that the resource is loaded
			this.sendLoadedNotification(PLAYLIST_LOADED,NAME,SRNAME); 
		}
		
		public function get playlist():PlaylistVO
		{
			return this.data as PlaylistVO;
		}

	}
}