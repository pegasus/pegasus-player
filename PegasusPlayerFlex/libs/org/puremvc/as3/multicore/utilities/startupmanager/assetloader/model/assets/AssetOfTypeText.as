/*
	PureMVC Utility - Startup Manager
	Copyright (c) 2008 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.assets
{
	import mx.core.UIComponent;
	import mx.controls.TextArea;

    import org.puremvc.as3.multicore.utilities.startupmanager.StartupManager;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.interfaces.IAssetForFlex;
    import org.puremvc.as3.multicore.utilities.startupmanager.assetloader.model.AssetGroupProxy;

	public class AssetOfTypeText extends AssetBase implements IAssetForFlex
	{
        private var _uiComponent :UIComponent;

		public function AssetOfTypeText( url :String ) {
		    super( url );
		}
		public function get type() :String {
		    return StartupManager.TEXT_ASSET_TYPE;
		}
		public function get uiComponent() :UIComponent {
		    if ( ! data )
		        return null;
		    if ( ! _uiComponent ) {
		        var txa :TextArea = new TextArea();
		        txa.text = data.toString();
		        _uiComponent = txa;
		    }
		    return _uiComponent;
		}

	}
}