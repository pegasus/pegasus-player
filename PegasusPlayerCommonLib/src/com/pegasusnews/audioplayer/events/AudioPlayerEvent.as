package com.pegasusnews.audioplayer.events
{
	import flash.events.Event;
	import flash.media.Sound;

	public class AudioPlayerEvent extends Event
	{
		public static const AUDIO_POSITION_UPDATE:String = "positionUpdate";
		public static const AUDIO_PLAYER_READY:String = "audioPlayerPaused";
		public static const AUDIO_PLAYER_ERROR:String = "audioPlayerError";
		public static const AUDIO_PLAYER_PAUSED:String = "audioPlayerPaused";
		public static const AUDIO_PLAYER_PLAYING:String = "audioPlayerPlaying";
		public static const AUDIO_PLAYER_STARTED:String = "audioPlayerStarted";
		public static const AUDIO_PLAYER_STOPPED:String = "audioPlayerStopped";
		public static const AUDIO_BUFFERING_COMPLETE:String = "audioBufferingComplete";
		public static const AUDIO_BUFFER_PROGRESS:String = "audioBufferProgress";
		public static const AUDIO_SONG_COMPLETE:String = "audioSongComplete";
		public static const AUDIO_ID3_AVAILABLE:String = "audioId3Available";
		
		public var sound:Sound;
		
		public function AudioPlayerEvent(type:String, sound:Sound)
		{
			this.sound = sound;
			super(type);
		}
		
		override public function clone():Event
		{
			return new AudioPlayerEvent(this.type, this.sound);
		}
		
	}
}