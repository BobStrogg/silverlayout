package com.chriscavanagh.Silverlayout
{
	import alducente.services.WebService;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class FrameworkElement extends Sprite
	{
		private static var suspendCount : int = 0;

		private var horizontalAlignment : String;
		private var verticalAlignment : String;
		private var padding : Number;
		private var desiredWidth : *;
		private var desiredHeight : *;
		private var background : *;
		private var backgroundAlpha : Number;
		private var opacity : Number;
		private var visibility : String;
		private var gridColumn : int;
		private var gridRow : int;

		private var measuredSize : Size;
		private var renderSize : Size;
		private var rendered : Boolean;

		private var offset : Point;
		private var tag : *;

		public function FrameworkElement()
		{
			horizontalAlignment = "Stretch";
			verticalAlignment = "Stretch";
			padding = 0;
			desiredWidth = null;
			desiredHeight = null;
			opacity = 1;
			visibility = "Visible";
			gridColumn = 0;
			gridRow = 0;
			rendered = false;
			alpha = 0;
			background = null;
			backgroundAlpha = 1;
			offset = new Point();

			addEventListener( Event.ADDED_TO_STAGE, OnAddedToStage );
			addEventListener( Event.RENDER, OnRender );
			addEventListener( Event.ENTER_FRAME, OnEnterFrame );
		}

		protected function OnAddedToStage( event : Event  ) : void
		{
		}

		private function OnRender( event : Event ) : void
		{
			this.graphics.clear();

			if ( !( parent is FrameworkElement ) )
			{
				var size : Size = Measure( new Size( parent.width, parent.height ) );
				Arrange( size );
			}

			var matrix : Matrix = new Matrix( 1, 0, 0, 1, padding, padding );
			matrix.translate( offset.x, offset.y );
			transform.matrix = matrix;

			OnRenderOverride( event );
		}

		protected function OnRenderOverride( event : Event ) : void
		{
			if ( background != null && renderSize )
			{
				var g : Graphics = this.graphics;

				g.beginFill( background, backgroundAlpha );
				g.drawRect(
					-padding,
					-padding,
					renderSize.Width + ( Padding * 2 ),
					renderSize.Height + ( Padding * 2 ) );
				g.endFill();
			}

			this.visible = ( visibility.toLowerCase() == "visible" );
		}

		private function OnEnterFrame( event : Event ) : void
		{
			if ( measuredSize && alpha != opacity && visibility.toLowerCase() == "visible" )
			{
				if ( rendered && Math.abs( opacity - alpha ) > 0.05 ) alpha += ( opacity - alpha ) * 0.2;
				else alpha = opacity;

				rendered = true;
			}
		}

		public function Measure( availableSize : Size ) : Size
		{
			if ( visibility.toLowerCase() == "collapsed" )
			{
				measuredSize = null;
				return new Size();
			}

			var doublePadding : Number = padding * 2;

			var desiredSize : Size = new Size(
				Math.max( 0, ( Width ? Width : availableSize.Width ) - doublePadding ),
				Math.max( 0, ( Height ? Height : availableSize.Height ) - doublePadding ) );

			var size : Size = MeasureOverride( desiredSize );

			measuredSize = new Size(
				( ( HorizontalAlignment.toLowerCase() == "stretch" || Width ) ? desiredSize.Width : Math.min( desiredSize.Width, size.Width ) ) + doublePadding,
				( ( VerticalAlignment.toLowerCase() == "stretch" || Height ) ? desiredSize.Height : Math.min( desiredSize.Height, size.Height ) ) + doublePadding );

			return measuredSize;
		}

		public function MeasureOverride( availableSize : Size ) : Size
		{
			var largest : Size = new Size( 0, 0 );

			for ( var index : int = 0; index < numChildren; ++ index )
			{
				var child : FrameworkElement = getChildAt( index ) as FrameworkElement;

				if ( child != null )
				{
					var size : Size = child.Measure( availableSize );
					if ( size.Width > largest.Width ) largest.Width = size.Width;
					if ( size.Height > largest.Height ) largest.Height = size.Height;
				}
			}

			return largest;
		}

		public function Arrange( finalSize : Size ) : Size
		{
			if ( visibility.toLowerCase() == "collapsed" ) return new Size();

			var doublePadding : Number = padding * 2;
			var availableSize : Size = new Size(
				Math.max( 0, ( measuredSize ? measuredSize.Width : finalSize.Width ) - doublePadding ),
				Math.max( 0, ( measuredSize ? measuredSize.Height : finalSize.Height ) - doublePadding ) );
			var size : Size = ArrangeOverride( availableSize );

			renderSize = availableSize;

			return new Size( size.Width + doublePadding, size.Height + doublePadding );
		}

		public function ArrangeOverride( finalSize : Size ) : Size
		{
			this.visible = ( visibility.toLowerCase() == "visible" );

			for ( var index : int = 0; index < numChildren; ++ index )
			{
				var child : FrameworkElement = getChildAt( index ) as FrameworkElement;

				if ( child != null )
				{
					var size : Size = child.Arrange( finalSize );
					var h : Extent = GetExtent( child.HorizontalAlignment, size.Width, finalSize.Width );
					var v : Extent = GetExtent( child.VerticalAlignment, size.Height, finalSize.Height );

					child.offset = new Point( h.Offset, v.Offset );
				}
			}

			return finalSize;
		}

		protected function GetExtent( alignment : String, size : Number, max : Number ) : Extent
		{
			switch ( alignment.toLowerCase() )
			{
				case "center": return new Extent( ( max - size ) / 2, size );

				case "top":
				case "left": return new Extent( 0, size );

				case "bottom":
				case "right": return new Extent( max - size, size );
			}

			return new Extent( 0, max );
		}

		public function Invalidate() : void
		{
			if ( stage && suspendCount == 0 ) stage.invalidate();
//			renderInvalid = true;
		}

		public function get HorizontalAlignment() : String { return horizontalAlignment; }
		public function set HorizontalAlignment( value : String ) : void { horizontalAlignment = value; Invalidate(); }
		public function get VerticalAlignment() : String { return verticalAlignment; }
		public function set VerticalAlignment( value : String ) : void { verticalAlignment = value; Invalidate(); }
		public function get Padding() : Number { return padding; }
		public function set Padding( value : Number ) : void { padding = value; Invalidate(); }
		public function get Width() : * { return desiredWidth; }
		public function set Width( value : * ) : void { desiredWidth = value; Invalidate(); }
		public function get Height() : * { return desiredHeight; }
		public function set Height( value : * ) : void { desiredHeight = value; Invalidate(); }
		public function get Opacity() : * { return opacity; }
		public function set Opacity( value : * ) : void { opacity = value; Invalidate(); }
		public function get Background() : * { return background; }
		public function set Background( value : * ) : void { background = value; Invalidate(); }
		public function get BackgroundAlpha() : * { return backgroundAlpha; }
		public function set BackgroundAlpha( value : * ) : void { backgroundAlpha = value; Invalidate(); }
		public function get Visibility() : String { return visibility; }
		public function set Visibility( value : String ) : void { visibility = value; Invalidate(); }
		public function get GridColumn() : int { return gridColumn; }
		public function set GridColumn( value : int ) : void { gridColumn = value; Invalidate(); }
		public function get GridRow() : int { return gridRow; }
		public function set GridRow( value : int ) : void { gridRow = value; Invalidate(); }

		public function get MeasuredSize() : Size { return measuredSize; }
		public function get RenderSize() : Size { return renderSize; }

		public function get Offset() : Point { return offset; }
		public function set Offset( value : Point ) : void { offset = value; }
		public function get Tag() : * { return tag; }
		public function set Tag( value : * ) : void { tag = value; }

		public static function Suspend() : void { ++ suspendCount; }
		public static function Resume() : void { -- suspendCount; }
	}
}