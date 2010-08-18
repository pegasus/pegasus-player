package com.pegasusnews.audioplayer
{
	import com.carlcalderon.arthropod.Debug;
	import com.ericfeminella.collections.HashMap;
	import com.pegasusnews.audioplayer.enum.AudioPlayerExternalEventEnum;
	import com.pegasusnews.audioplayer.events.AudioPlayerErrorEvent;
	import com.pegasusnews.audioplayer.events.AudioPlayerEvent;
	import com.pegasusnews.util.Format;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;

	[Event(name="audioPositionUpdate",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioPlayerPaused",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioPlayerError",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioPlayerPaused",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioPlayerPlaying",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioPlayerStarted",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioPlayerStopped",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioBufferingComplete",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioBufferProgress",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioSongComplete",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="audioId3Available",type="com.pegasusnews.audioplayer.events.AudioPlayerEvent")]
	[Event(name="incompatibleFileFormat",type="com.pegasusnews.audioplayer.events.AudioPlayerErrorEvent")]
	
	/**
	 * AudioPlayer is the base class for a Flash MP3 player that functions as
	 * both a 'chromeless' and skinned player. Various ExternalInterface methods/callbacks 
	 * are used to provide an API for JavaScript to interface with.
	 * 
	 * <p>Calls to ExternalInterface:
	 * ExternalInterface.call("setBufferState", true);
	 * ExternalInterface.call("updateProgress", this.percentLoaded, this._soundChannel.position, this._sound.length);
	 * ExternalInterface.call("flashReady", true)
	 * ExternalInterface.call("updateVolume", value);
	 * ExternalInterface.call("songComplete");
	 * ExternalInterface.call("songPosition", Format.formatTimecode(this._soundChannel.position), Format.formatTimecode(this._sound.length));
	 * ExternalInterface.call("updateID3", {artist:id3.artist, album:id3.album, songName:id3.songName, year:id3.year});</p>
	 *
	 * <p>Methods exposed to the ExternalInterface 
	 * ExternalInterface.addCallback("fl_load_mp3", this.load);
	 * ExternalInterface.addCallback("fl_play_mp3", this.play);
	 * ExternalInterface.addCallback("fl_pause_mp3", this.pause);
	 * ExternalInterface.addCallback("fl_stop_mp3", this.stop);
	 * ExternalInterface.addCallback("fl_jump_song_position", this.jumpToSongPosition);
	 * ExternalInterface.addCallback("fl_volume_mp3", this.setVolume);
	 * ExternalInterface.addCallback("fl_get_status", this.getStatus);
	 * ExternalInterface.addCallback("fl_current_position", this.getCurrentPosition);
	 * ExternalInterface.addCallback("fl_song_length", this.getSongLength);
	 * ExternalInterface.addCallback("fl_register_event", this.registerExternalEvent);
	 * ExternalInterface.addCallback("fl_unregister_event", this.unregisterExternalEvent);</p>
	 * 
	 * @author joel
	 * 
	 */	
	[Bindable]
	public class AudioPlayer extends EventDispatcher
	{
		/**
		 * HashMap of events registered with the ExternalInterface. 
		 */		
		protected var registeredEvents:HashMap = new HashMap();
		
		/**
		 * Stored position when a Sound is paused so that it may be
		 * accurately resumed.
		 */		
		protected var _pausePosition:Number = 0.0;
		
		/**
		 * The Sound's buffering status. 
		 */		
		protected var _isBuffering:Boolean = false;
		
		public function get isBuffering():Boolean
		{
			return _isBuffering;
		}
		
		public function set isBuffering(v:Boolean):void
		{
			this._isBuffering = v;
		}

		
		/**
		 * The AudioPlayer's readiness state. 
		 */		
		protected var _isReady:Boolean = false;
		
		/**
		 * Total size of the file in bytes. 
		 */
		protected var _fileBytesTotal:Number = 0.0;

		/**
		 * Total bytes loaded of the current Sound. 
		 */
		protected var _fileBytesLoaded:Number = 0.0;
		
		/**
		 * SoundTransform of the current Sound. Controls volume
		 * and panning. 
		 */		
		protected var _soundTransform:SoundTransform = new SoundTransform(1,0)
		
		/**
		 * The actual audio channel the Sound is playing through. 
		 */		
		protected var _soundChannel:SoundChannel;
		
		/**
		 * The song. 
		 */
		protected var _sound:Sound = new Sound();
		
		protected var _autoplay:Boolean = true;

		public function get autoplay():Boolean
		{
			return _autoplay;
		}

		public function set autoplay(v:Boolean):void
		{
			_autoplay = v;
		}

		
		/**
		 * 1 second interval timer used to update the current status/position
		 * of the Sound. 
		 */		
		protected var _positionUpdateTimer:Timer = new Timer(1000);
		
		protected var opaque:Object = {};
		
		protected var root:DisplayObject;
		
		/**
		 * constructor 
		 */		
		public function AudioPlayer(root:DisplayObject, autoplay:Boolean=true)
		{
			this.root = root;
			this.autoplay = autoplay;
			createExternalCallbacks()
			this.init();
		}
		
		/**
		 * is the file currently playing? 
		 */		
		protected var _isPlaying:Boolean = false;
		public function get isPlaying():Boolean { return this._isPlaying }
		
		/**
		 * the percentage loaded of the current file 
		 * @return percentage loaded 
		 * 
		 */		
		public function get percentLoaded():int
		{
			return Math.floor(this._fileBytesLoaded/this._fileBytesTotal*100)
		}
		
		public function get currentPosition():int
		{
			if(this._soundChannel)
				return Math.floor(this._soundChannel.position);
			return 0;
		}
		
		/**
		 * get/set url of mp3 to play 
		 */
		protected var _url:String;
		public function get url():String { return this._url }
		
		/**
		 * get/set volume property 
		 */		
		protected var _volume:Number = 1.0;
		public function get volume():Number { return this._volume }
		public function set volume(value:Number):void
		{
			if(value>1.0)
				value = 1.0;
			if(value<0)
				value = 0;
			
			this._volume = value;
			this._soundTransform.volume = value;
			
			if(this._soundChannel)
				this._soundChannel.soundTransform = this._soundTransform;
			ExternalInterface.call("updateVolume", value);
		}
		
		/**
		 * load an mp3 located at the currently defined url endpoint. 
		 */
		protected function init():void
		{
			this._sound = new Sound()
			this._positionUpdateTimer = new Timer(1000);
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, handleSoundLoadError);
			this._sound.addEventListener(ProgressEvent.PROGRESS, handleSoundProgress)
			this._sound.addEventListener(Event.COMPLETE, handleSoundComplete);
			this._sound.addEventListener(Event.ID3, handleID3);
			this._sound.addEventListener(Event.OPEN, handleSoundOpen)
			this._positionUpdateTimer.addEventListener(TimerEvent.TIMER, handlePositionTimer);
			
			Security.allowDomain("www.dev.pegasusnews.com");
			Security.allowDomain("www.dev.wiredlocal.com");
			Security.allowDomain("www.pegasusnews.com");
			Security.allowDomain("www.wiredlocal.com");
			Security.allowDomain("media.pegasusnews.com");
			Security.allowDomain("devmedia.pegasusnews.com");
			Security.allowDomain("media.wiredlocal.com");
			Security.allowDomain("devmedia.wiredlocal.com");
			if(!this._isReady)
			{
				this._isReady = true;
				//AS3 version will have a root object to extract FlashVars from
				if(this.root && this.root.loaderInfo.parameters.player_id)
					ExternalInterface.call("flashReady", this.root.loaderInfo.parameters.player_id)
				this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_PLAYER_READY, this._sound));	
				Debug.log("Flash is Ready");
			}			
		}	
		
		/**
		 * Register the exposed methods with the ExternalInterface. 
		 */		
		protected function createExternalCallbacks():void
		{
			ExternalInterface.addCallback("fl_load_mp3", this.load);
			ExternalInterface.addCallback("fl_play_mp3", this.play);
			ExternalInterface.addCallback("fl_pause_mp3", this.pause);
			ExternalInterface.addCallback("fl_stop_mp3", this.stop);
			ExternalInterface.addCallback("fl_jump_song_position", this.jumpToSongPosition);
			ExternalInterface.addCallback("fl_volume_mp3", this.setVolume);
			ExternalInterface.addCallback("fl_get_status", this.getStatus);
			ExternalInterface.addCallback("fl_current_position", this.getCurrentPosition);
			ExternalInterface.addCallback("fl_song_length", this.getSongLength);
			ExternalInterface.addCallback("fl_register_event", this.registerExternalEvent);
			ExternalInterface.addCallback("fl_unregister_event", this.unregisterExternalEvent);
		}
		
		/**
		 * Load a Sound from a URL. Exposed to the ExternalInterface.
		 * @param url
		 * @param opaque
		 */		
		public function load(url:String, opaque:Object = null):void
		{
			if(opaque)
				this.opaque = opaque;
			Debug.log("Loading song from url: " + url);
			this._pausePosition = 0;
			this.isBuffering = true;
			this.reset();
			this.init();
			this._url = url;
			var request:URLRequest = new URLRequest(this._url);
			var context:SoundLoaderContext = new SoundLoaderContext(10000, true);	
			this._sound.load(request, context);

			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_SET);
			ExternalInterface.call("songPosition", Format.formatTimecode(0), Format.formatTimecode(this._sound.length));
		}

		/**
		 * The total length of the current Sound (in seconds). Exposed to the ExternalInterface.
		 * @return 
		 */		
		public function getSongLength():Number
		{
			return this._sound.length/1000;
		}
		
		/**
		 * The current position of the Sound (in seconds).
		 * Exposed to the ExternalInterface.
		 * @return 
		 * 
		 */		
		public function getCurrentPosition():Number
		{
			return this._soundChannel.position/1000
		}
		
		public function getFormatedPosition():String
		{
			return Format.formatTimecode(this._soundChannel.position) + "/" + Format.formatTimecode(this._sound.length);
		}

        /**
         * The current position of the Sound (0.0-1.0)
         * @return 
         * 
         */     
        public function getCurrentPlayedPercentage():Number
        {
            var percent:Number =  this.getCurrentPosition() / this._sound.length * 1000;
            return percent;
        }

		/**
		 * Jump to a specified percentile position in the current Sound.
		 * Exposed to the ExternalInterface.
		 *  
		 * @param percent
		 */		
		public function jumpToSongPosition(percent:Number):void
		{
			
			var position:Number = (percent/100) * this._sound.length;
			trace("the new position is: ", position);
			if(this.isPlaying)
			{
				Debug.log("Jumping to playing position: " + int(position));
				this._soundChannel.stop();
				this._soundChannel = this._sound.play(position);
				if(!this._soundChannel.hasEventListener(Event.SOUND_COMPLETE))
					this._soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSongComplete)
				this._soundChannel.soundTransform = this._soundTransform;
				ExternalInterface.call("songPosition", Format.formatTimecode(this._soundChannel.position), Format.formatTimecode(this._sound.length));
			}
			else
			{
				Debug.log("Jumping to paused position: " + int(position));
				this._pausePosition = position;
				ExternalInterface.call("songPosition", Format.formatTimecode(this._pausePosition), Format.formatTimecode(this._sound.length));
			}
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_ELAPSE);
		}
		
		/**
		 * Toggle the current pause/play state of the Sound. 
		 */		
		public function togglePauseAndPause():void
		{
			if(this._isPlaying)
				this.pause();
			else
				this.play();
		}
		
		/**
		 * Pause the current Sound. Exposed to the ExternalInterface. 
		 */		
		public function pause():void
		{
			if(!this.isPlaying)
				return;
			this._pausePosition = this._soundChannel.position;
			this._soundChannel.stop();
			this._isPlaying = false;
			this._positionUpdateTimer.stop();	
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_PLAYER_PAUSED, this._sound));	
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_ELAPSE);	
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_PAUSE);
			Debug.log("Pausing player at: " + int(this._pausePosition));
		}
		
		/**
		 * Play the current Sound. Exposed to the ExternalInterface. 
		 */		
		public function play():void
		{
			if(this._isPlaying)
				return;
			this._soundChannel = this._sound.play(this._pausePosition);
			if(!this._soundChannel.hasEventListener(Event.SOUND_COMPLETE))
				this._soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSongComplete)
			this._soundTransform.volume = this._volume;
			this._soundChannel.soundTransform = this._soundTransform;
			this._isPlaying = true;
			this._positionUpdateTimer.start();	
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_PLAYER_PLAYING, this._sound));		
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_ELAPSE);
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_PLAY);
			Debug.log("Play from: " + int(this._pausePosition));
		}
		
		/**
		 * Stop the audio file and return playhead to 0.0. Exposed to the ExternalInterface.
		 */		
		public function stop():void
		{
			if(this._isPlaying)
			{
				this._soundChannel.stop();
				this._isPlaying = false;
			}
			this._pausePosition = 0.0;
			this._positionUpdateTimer.stop();
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_PLAYER_STOPPED, this._sound));
			ExternalInterface.call("songPosition", Format.formatTimecode(0), Format.formatTimecode(this._sound.length));
			Debug.log("Playback stopped");
		}
		
		/**
		 * Gets the status of the current sound. Exposed to the ExternalInterface. 
		 * @return 
		 * 
		 */		
		public function getStatus():Object
		{
			Debug.log("Status isplaying:" + this.isPlaying + " mp3_url:" + this.url);
			return {isPlaying:this._isPlaying, mp3URL:this._url,opaque:opaque};
		}

		/**
		 * Sets the volume of the current Sound. Exposed to the ExternalInterface. 
		 * @param value
		 * 
		 */		
		protected function setVolume(value:Number):void
		{
			Debug.log("Setting volume to: " + value);
			this.volume = value;
		}
		
		/**
		 * Remove event listeners and null properties of the current Sound for garbage collection, 
		 * This method is called when a new song is loaded. Will also attempt to close any streams 
		 * and stop any SoundChannels related to the current Sound.
		 */		
		protected function reset():void
		{
	        try
	        {
	        	this._sound.close();
	        }
	        catch(error:Error) {}
	        try
	        {
	        	this._soundChannel.stop();
	        }
	        catch(error:Error) {}
	        
	        this._isPlaying = false;
			this._sound.removeEventListener(IOErrorEvent.IO_ERROR, handleSoundLoadError);
			this._sound.removeEventListener(ProgressEvent.PROGRESS, handleSoundProgress)
			this._sound.removeEventListener(Event.COMPLETE, handleSoundComplete);
			this._sound.removeEventListener(Event.ID3, handleID3);
			this._sound.removeEventListener(Event.OPEN, handleSoundOpen)
			if(this._soundChannel && this._soundChannel.hasEventListener(Event.SOUND_COMPLETE))
				this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, handleSongComplete)
			this._positionUpdateTimer.removeEventListener(TimerEvent.TIMER, handlePositionTimer);
			this._positionUpdateTimer.stop();
			this._sound = null;
			this._soundChannel = null;
			Debug.log("Player reset");
		}
		

		
		/**
		 * Register and event with the external interface. Event name must
		 * be enumerated in <code>AudioPlayerExternalEventEnum</code> or it will not
		 * be added.
		 * 
		 * @param name The name of the event to register
		 * @param callable The name of the method in the ExternalInterface to call for this event.
		 * 
		 */		
		protected function registerExternalEvent(name:String, callable:String):void
		{
			if(AudioPlayerExternalEventEnum.eventAvailable(name))
			{
				Debug.log("Registering external event:" + name + " mapped to: " + callable);
				this.registeredEvents.put(name, callable);
				trace("registering event:", name, "with callable", callable);
			}
				
		}
		
		/**
		 * Unregister an event with the ExternalInterface 
		 * @param name The name of the event.
		 * 
		 */		
		protected function unregisterExternalEvent(name:String):void
		{
			if(this.registeredEvents.containsKey(name))
			{
				Debug.log("Unregistering event: " + name);
				this.registeredEvents.remove(name);
				trace("unregistering event: ", name);
			}
			else
			{
				Debug.log("Attempt to unregister nonexistant event: " + name);
			} 
				
		}
		/**
		 * Calls an ExternalInterface method based on registered events. If event isn't registered
		 * via the ExternalInterface, it will not make any calls.
		 * 
		 * <p>The parameters sent to ExternalInterface are URL, Current Song Position, and the Opaque object.</p> 
		 * @param eventName The name of the event to call.
		 * 
		 */		
		protected function callExternalEvent(eventName:String):void
		{
			if(this.registeredEvents.containsKey(eventName))
			{
				ExternalInterface.call(this.registeredEvents.getValue(eventName), this._url, this._soundChannel.position, this.opaque);
				Debug.log("Calling external event: " + eventName);
			}
				
		}	
		
		////////////////////////////
		// event handlers
		////////////////////////////
		
		protected function handleSoundLoadError(error:IOErrorEvent):void
		{
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_PLAYER_ERROR, this._sound));	
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_ERROR);
			Debug.log("Error occured loading song: " + error.text, Debug.RED);
		}
		
		protected function handleSoundProgress(event:ProgressEvent):void
		{
			this.isBuffering = true;
			this._fileBytesTotal = event.bytesTotal;
			this._fileBytesLoaded = event.bytesLoaded;
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_BUFFER_PROGRESS, this._sound));
		}
		
		protected function handleSoundComplete(event:Event):void
		{
			var fileExtension:String = this._sound.url.split(".").pop()
			if(fileExtension.toLowerCase() != "mp3")
			{
				Debug.log("ERROR:", Debug.RED);
				Debug.log("--" + AudioPlayerErrorEvent.INCOMPATIBLE_FILE_FORMAT, Debug.LIGHT_YELLOW);
				this.dispatchEvent(new AudioPlayerErrorEvent(AudioPlayerErrorEvent.INCOMPATIBLE_FILE_FORMAT, "Cannot play song. Incompatible file type.", this._sound));
			}
			this.isBuffering = false;
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_BUFFERING_COMPLETE, this._sound));
			ExternalInterface.call("setBufferState", false);
			Debug.log("Song buffering complete");
		}
		
		protected function handlePositionTimer(event:TimerEvent):void
		{
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_POSITION_UPDATE, this._sound));
			if(Format.formatTimecode(this._sound.length) == Format.formatTimecode(this._soundChannel.position))
			{
				//moved to another listener
				/*this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_SONG_COMPLETE, this._sound));
				this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_COMPLETE);
				stop();
				Debug.log("Song finished.");*/
			}
			ExternalInterface.call("songPosition", Format.formatTimecode(this._soundChannel.position), Format.formatTimecode(this._sound.length));
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_ELAPSE);
		}

		protected function handleSongComplete(event:Event):void
		{
			this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_SONG_COMPLETE, this._sound));
			this.callExternalEvent(AudioPlayerExternalEventEnum.SONG_COMPLETE);
			stop();
			Debug.log("Song finished.");			
		}
		
		protected function handleID3(event:Event):void
		{
			try
			{
				var id3:ID3Info = this._sound.id3;
				ExternalInterface.call("updateID3", {artist:id3.artist, album:id3.album, songName:id3.songName, year:id3.year});
				this.dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.AUDIO_ID3_AVAILABLE, this._sound));
				Debug.log("ID3 Loaded: " + this._sound.id3.artist);			
			}
			catch(error:Error)
			{
				Debug.log("Error loading ID3: " + error.name, Debug.RED);
			}
		}
		
		protected function handleSoundOpen(event:Event):void
		{
			Debug.log("Song has been opened");
			this._pausePosition = 0.0;
			if(this.autoplay)
			{
				Debug.log("Autoplaying.");
				this.play();
			}
			
		}
	}
}