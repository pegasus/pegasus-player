/*
* Created by: joel
* Created on: Jun 14, 2009
*/
package com.pegasusnews.audioplayer.events
{
	import flash.events.Event;
	import flash.media.Sound;

	/**
	 * TODO: Write a meaningful description of this Class.
	*/
	public class AudioPlayerErrorEvent extends Event
	{
		public static const INCOMPATIBLE_FILE_FORMAT:String = "incompatibleFileFormat";
		
		private var _sound:Sound;
		public function get sound():Sound { return this._sound }
		
		private var _message:String;
		public function get message():String { return _message;	}
		
		public function AudioPlayerErrorEvent(type:String, message:String, sound:Sound=null)
		{
			this._message = message;
			this._sound = sound;
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			return new AudioPlayerErrorEvent(this.type, this._message, this._sound);
		}
	}
}