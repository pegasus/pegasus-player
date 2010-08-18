/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.model
{
	import com.carlcalderon.arthropod.Debug;
	import com.pegasusnews.playlist.model.vo.ConfigVO;
	
	import mx.core.Application;
	
	import org.puremvc.as3.multicore.utilities.startupmanager.interfaces.IStartupProxy;
	import org.puremvc.as3.multicore.utilities.startupmanager.model.EntityProxy;

	/**
	* Proxy that reads and stores FlashVar values
	*/
	public class ConfigProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "ConfigProxy";
		public static const SRNAME:String = "SR" + NAME;
		
		public static const CONFIG_LOADED:String = "note/configLoaded";
		public static const CONFIG_FAILED:String = "note/configFailed";
		
		public static const CONFIG_READY:String = "note/configReady";
		
		public function ConfigProxy()
		{
			super(NAME);
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
		}
		
		public function load():void
		{
			readFlashVars();
		}
		
		private function readFlashVars():void
		{
			this.data = new ConfigVO();
			Debug.log("Parsing FlasVars for Config", Debug.LIGHT_BLUE)
			var params:Object = Application.application.parameters;
			this.config.autoplay = params.autoplay;
			this.config.feed = params.feed;
			this.config.position = params.position;
			this.config.base_url = params.base_url;
			Debug.log(this.config.toString());
			
			// call the StartupMonitorProxy for notify that the resource is loaded
			this.sendLoadedNotification(CONFIG_LOADED,NAME,SRNAME); 
		}
		
		public function get config():ConfigVO
		{
			return this.data as ConfigVO;
		}
	}
}