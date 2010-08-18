package {
	
	import com.carlcalderon.arthropod.Debug;
	import com.pegasusnews.audioplayer.AudioPlayer;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;

	[SWF(width='1', height='1', backgroundColor='#ffffff', frameRate='30')]

	public class PegasusPlayer extends Sprite
	{
		private var audioPlayer:AudioPlayer;
		
		public function PegasusPlayer()
		{
			Debug.log("Starting Audio Player"); 
			this.audioPlayer = new AudioPlayer(this.root);
		}
	}
}
