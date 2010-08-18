package org.puremvc.as3.multicore.utilities.pipes.events
{
	import flash.events.Event;

	public class PipeEvent extends Event
	{
		public static var DISCONNECT_FITTING:String = "diconnectFitting";
		
		public function PipeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new PipeEvent(this.type,this.bubbles,this.cancelable);
		}
		
	}
}