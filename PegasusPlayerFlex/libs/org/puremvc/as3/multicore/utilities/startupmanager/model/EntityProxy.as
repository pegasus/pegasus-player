package org.puremvc.as3.multicore.utilities.startupmanager.model
{
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import org.puremvc.as3.multicore.utilities.startupmanager.model.StartupResourceProxy;
    
    /**
    *   An abstract class, to facilitate the actual resource proxies.
    */
    public class EntityProxy extends Proxy implements IProxy
    {
        public function EntityProxy( name :String ) {
            super( name );
        }

        /**
         *  Resource has been loaded.  We send a loaded notification.
         *  However, to keep the presentation clean within the demo, that is,
         *  to keep in sync with the Startup Manager (SM) and avoid an incorrect
         *  'loaded' notification on our display screen, only send the
         *  notification if the SM has not timed out this resource.
         *  This is a matter for the demo; the SM knows to ignore any such
         *  loaded notifications.
         */
        protected function sendLoadedNotification( noteName :String, noteBody :Object, srName :String ) :void {
            var srProxy:StartupResourceProxy = facade.retrieveProxy( srName ) as StartupResourceProxy;
            if ( ! srProxy.isTimedOut() )
                sendNotification( noteName, noteBody );
        }

        

    }

}