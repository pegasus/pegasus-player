/*
* Created by: joel
* Created on: Jun 13, 2009
*/
package com.pegasusnews.playlist.view.controls
{
	import com.pegasusnews.playlist.model.vo.ConfigVO;
	import com.pegasusnews.playlist.model.vo.FavoriteVO;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Image;

	/**
	 * TODO: Write a meaningful description of this Class.
	*/
	public class FavoriteButton extends Image
	{

        [Embed(source="/assets/controls.swf", symbol="heart")]
        private var EnabledIcon:Class;

        [Embed(source="/assets/controls.swf", symbol="heartOff")]
        private var DisabledIcon:Class;
        
        public var favorite:FavoriteVO;
        public var config:ConfigVO;
                		
		public function FavoriteButton()
		{
		    super();
		    this.buttonMode = true;
		    this.mouseChildren = false;
		    this.source = DisabledIcon;
		    this.addEventListener(MouseEvent.CLICK, handleClick)
		}
		
		override public function set enabled(value:Boolean) : void
		{
		    super.enabled = value;
		    if(value)
		    {
		        this.source = EnabledIcon;
		        this.toolTip = "remove this from favorites";
		    }
		    else
		    {
		        this.source = DisabledIcon;
		        this.toolTip = "add this to favorites";
		    }
		}
		
		private function handleClick(event:MouseEvent):void
		{
			var request:URLRequest = new URLRequest(this.config.base_url + this.favorite.favorite);
			if(this.favorite.is_favorited)
			{
				request.url = this.config.base_url + this.favorite.unfavorite;
				this.favorite.is_favorited = false;
				this.enabled = false;
			}
			else
			{
				this.favorite.is_favorited = true;
				this.enabled = true;				
			}
				
			flash.net.navigateToURL(request, "_blank")
		}
	}
}