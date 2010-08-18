/*
* Created by: joel
* Created on: Jun 4, 2009
*/
package com.pegasusnews.playlist.model.vo
{
	import com.carlcalderon.arthropod.Debug;
	
	import flash.events.EventDispatcher;
	
	import mx.formatters.DateFormatter;

	/**
	* TODO: Write a meaningful description of this Class.
	*/
	[Bindable]
	public class EventVO extends EventDispatcher
	{
		public var time:Date;
		public var href:String;
		
		public function EventVO(JSONObject:Object=null)
		{
			if(JSONObject)
				this.parseJSON(JSONObject)
		}
		
		private function parseJSON(object:Object):void
		{
			this.time = this.parseDate(object.time);
			this.href = object.href;
			//Debug.log(this.toString());
		}
		
		private function parseDate(date:String):Date
		{
			var dateParts:Array = date.split(" ");
			var dayParts:Array = dateParts[0].split("-");
			var timeParts:Array = dateParts[1].split(":");
			var returnDate:Date = new Date(dayParts[0],dayParts[1]-1,dayParts[2],timeParts[0],timeParts[1],timeParts[2]);
			return returnDate;
		}
		
		override public function toString():String
		{
			var formatter:DateFormatter = new DateFormatter()
			formatter.formatString = "MM/DD/YY at L:NN A"
			return "[EventVO "+formatter.format(this.time)+"]";
		}
	}
}