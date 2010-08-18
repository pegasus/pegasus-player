package com.pegasusnews.audioplayer.enum
{
	public class AudioPlayerExternalEventEnum
	{
		public static const SONG_ERROR:String = "songError";
		public static const SONG_ELAPSE:String = "songElapse";
		public static const SONG_SET:String = "songSet";
		public static const SONG_PLAY:String = "songPlay";
		public static const SONG_PAUSE:String = "songPause";
		public static const SONG_COMPLETE:String = "songComplete";
		
		public static function get eventList():Array
		{
			return [ SONG_ERROR, SONG_ELAPSE, SONG_SET, SONG_PLAY, SONG_PAUSE, SONG_COMPLETE ];
		}
		
		public static function eventAvailable(name:String):Boolean
		{
			for each(var eventName:String in AudioPlayerExternalEventEnum.eventList)
			{
				if(eventName==name)
					return true;
			}
			return false;
		}

	}
}