package org.puremvc.as3.multicore.utilities
{
	import fr.kapit.puremvc.as3.multicore.patterns.facade.DebugFacade;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	CONFIG::release
	public class SwitchFacade extends Facade
	{
		public function SwitchFacade(key:String)
		{
			super(key)
		}

	}
	
	CONFIG::debug
	public class SwitchFacade extends DebugFacade
	{
		public function SwitchFacade(key:String)
		{
			super(key)
		}
	}
}