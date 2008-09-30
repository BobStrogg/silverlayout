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
	public class ContentControl extends FrameworkElement
	{
		protected var content : *;
		protected var contentSize : Size;
		protected var actualSize : Size;
		protected var contentOffset : Point;

		public function ContentControl( content : * = null )
		{
			actualSize = new Size();
			if ( content != null ) Content = content;
		}

		public function get Content() : * { return content; }

		public function set Content( content : * ) : void
		{
			if ( this.content ) removeChild( this.content );

			if ( content )
			{
				addChild( content );

				var loader : Loader = content as Loader;
				var rect : Rectangle = loader
					? new Rectangle( 0, 0, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height )
					: content.getBounds( this );

				contentSize = new Size( rect.width, rect.height );
				contentOffset = new Point( -rect.left, -rect.top );
			}
			else
			{
				contentSize = new Size();
				contentOffset = new Point();
			}

			this.content = content;
		}

		override public function MeasureOverride( availableSize : Size ) : Size 
		{
			if ( !contentSize ) return new Size( 0, 0 );

			var scale : Number = Math.min( Width ? Width / contentSize.Width : 1, Height ? Height / contentSize.Height : 1 );
			scale = Math.min( scale, Math.min( availableSize.Width / contentSize.Width, availableSize.Height / contentSize.Height ) );

			actualSize = new Size( contentSize.Width * scale, contentSize.Height * scale );

			return actualSize;
		}

		override public function ArrangeOverride( finalSize : Size ) : Size 
		{
			if ( content && contentSize )
			{
				var matrix : Matrix = new Matrix( 1, 0, 0, 1, contentOffset.x, contentOffset.y );
				matrix.scale( actualSize.Width / contentSize.Width, actualSize.Height / contentSize.Height );

				content.transform.matrix = matrix;
			}

			return actualSize;
		}
	}
}