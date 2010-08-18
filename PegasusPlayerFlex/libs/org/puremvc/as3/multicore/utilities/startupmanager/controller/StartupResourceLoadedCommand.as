/*
	PureMVC Utility - Startup Manager - Manage loading of data resources at application startup
	Copyright (c) 2007-2008, collaborative, as follows
	2007 Daniele Ugoletti, Joel Caballero
	2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.controller {
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupMonitorProxy;

	/**
	 *  Provides a command that is invoked when an application succeeds in
	 *  loading a startup resource.  The resource has been loaded by the
	 *  application's own resource proxy.
	 *  The command invocation is via a <code>Notification</code> 
	 *  sent by the application.  The body of the <code>Notification</code> MUST MUST
	 *  MUST identify the resource, using the application's resource proxy name.
	 *
	 *  <p>
	 *  This command must be registered for all the relevant notifications, for example
	 *  in the application's concrete facade.</p>
	 */
	public class StartupResourceLoadedCommand extends SimpleCommand implements ICommand {

		/**
		 * Inform the startup monitor that a resource has been loaded.
		 * The notification body identifies the particular resource.
		 */
		override public function execute( note:INotification ) : void {
		    ( facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy).
		        resourceLoaded( note.getBody() as String );
		}
	}
	
}
