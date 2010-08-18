package com.pegasusnews.util
{
	public class Format
	{
		/**
		 * Format millisecond time as M:SS timecode sting
		 * @param time
		 * @return 
		 */		
		public static  function formatTimecode(time:Number):String {
		        var min:String = Math.floor(time/60000).toString();
		        var sec:String = (Math.floor((time/1000)%60) < 10)? "0" + Math.floor((time/1000)%60).toString() : Math.floor((time/1000)%60).toString();
		
		        return(min+":"+sec);
		}	

	}
}