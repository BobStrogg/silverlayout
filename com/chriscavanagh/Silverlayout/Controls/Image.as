package com.chriscavanagh.Silverlayout.Controls
{
	import com.chriscavanagh.Silverlayout.*;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Image extends ContentControl
	{
		public static var LOADED : String = "LOADED";

		protected var source : String;
		protected var loader : Loader;

		public function Image( source : String = null )
		{
			if ( source != null ) Source = source;
		}

		public function get Source() : String { return source; }

		public function set Source( source : String ) : void
		{
			if ( loader == null )
			{
				loader = new Loader();

				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, function( event : Event ) : void
				{
					Content = loader;
//					contentSize = new Size( loader.contentLoaderInfo.width, loader.contentLoaderInfo.height );
					dispatchEvent( new Event( LOADED ) );
					Invalidate();
				} );
			}

			Content = null;
			loader.load( new URLRequest( source ) );

			this.source = source;
		}

		override protected function OnRenderOverride(event:Event):void 
		{
			if ( loader && RenderSize )
			{
				loader.width = RenderSize.Width;
				loader.height = RenderSize.Height;
			}

			super.OnRenderOverride(event);
		}
	}
}