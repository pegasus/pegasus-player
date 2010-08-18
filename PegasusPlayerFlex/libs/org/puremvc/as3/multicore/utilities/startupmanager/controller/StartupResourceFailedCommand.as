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
	 *  Provides a command that is invoked when an application fails to load
	 *  a startup resource.  The failure occurs within the application's own
	 *  resource proxy when it is carrying out the load activity.
	 *  The command invocation is via a <code>Notification</code> 
	 *  sent by the application.  The body of the <code>Notification</code> MUST MUST
	 *  MUST identify the resource, using the application's resource proxy name.  This
	 *  name can be simply a String object or can be embedded in a FailureInfo object.
	 *  <p>
	 *  This command must be registered for all the relevant notifications, for example
	 *  in the application's concrete facade.</p>
	 */
	public class StartupResourceFailedCommand extends SimpleCommand implements ICommand {

		/**
		 * Inform the startup monitor that a resource load has failed.
		 * The notification body identifies the particular resource; it can be a String or a FailureInfo.
		 */
		override public function execute( note:INotification ) : void {
		    var proxyName :String;
		    var allowRetry :Boolean = true;
		    var info :FailureInfo = note.getBody() as FailureInfo;
		    if ( info ) {
		        proxyName = info.proxyName;
		        allowRetry = info.allowRetry;
		    }
		    else {
		        proxyName = note.getBody() as String;
		    }
		    ( facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy).
		        resourceFailed( proxyName, allowRetry );
		}
	}
	
}
