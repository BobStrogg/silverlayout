package com.chriscavanagh.Silverlayout.Controls
{
	import com.chriscavanagh.Silverlayout.*;
	import flash.display.Graphics;
	import flash.events.Event;
	
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Border extends FrameworkElement
	{
		private var thickness : Number;
		private var strokeColor : uint;
		private var cornerRadius : Number;

		public function Border( background : * = null, strokeColor : uint = 0, thickness : Number = 0, cornerRadius : Number = 0 )
		{
			HorizontalAlignment = "Center";
			VerticalAlignment = "Center";

			this.Background = background;
			this.strokeColor = strokeColor;
			this.thickness = thickness;
			this.cornerRadius = cornerRadius;
		}

		override public function MeasureOverride(availableSize:Size):Size 
		{
			var desiredSize : Size = new Size(
				availableSize.Width - ( thickness * 2 ),
				availableSize.Height - ( thickness * 2 ) );

			var size : Size = super.MeasureOverride( desiredSize );

			return new Size(
				size.Width + ( thickness * 2 ),
				size.Height + ( thickness * 2 ) );
		}

		override public function ArrangeOverride(finalSize:Size):Size 
		{
			var size : Size = super.ArrangeOverride( finalSize );

			for ( var index : int = 0; index < numChildren; ++ index )
			{
				var child : FrameworkElement = getChildAt( index ) as FrameworkElement;

				if ( child != null )
				{
					child.Offset.x += thickness;
					child.Offset.y += thickness;
				}
			}
/*
			if ( thickness > 0 || background != null )
			{
				var g : Graphics = this.graphics;
				g.clear();

				if ( thickness > 0 )
				{
					g.lineStyle( thickness, strokeColor );
					g.drawRect( thickness / 2, thickness / 2, finalSize.Width - thickness, finalSize.Height - thickness );
				}

				if ( background != null )
				{
					g.beginFill( background, backgroundAlpha );
					g.drawRect(
						thickness / 2,
						thickness / 2,
						finalSize.Width + ( Padding * 2 ) - thickness,
						finalSize.Height + ( Padding * 2 ) - thickness );
					g.endFill();
				}
			}
*/
			return finalSize;
		}

		override protected function OnRenderOverride( event : Event ) : void 
		{
			if ( ( thickness > 0 || Background != null ) && RenderSize )
			{
				var g : Graphics = this.graphics;

				if ( thickness > 0 )
				{
					g.lineStyle( thickness, strokeColor );
					g.drawRoundRect(
						-Padding + ( thickness / 2 ),
						-Padding + ( thickness / 2 ),
						RenderSize.Width + ( Padding * 2 ) - thickness,
						RenderSize.Height + ( Padding * 2 ) - thickness,
						cornerRadius,
						cornerRadius );
				}

				if ( Background != null )
				{
					g.beginFill( Background, BackgroundAlpha );
					g.drawRoundRect(
						-Padding + ( thickness / 2 ),
						-Padding + ( thickness / 2 ),
						RenderSize.Width + ( Padding * 2 ) - thickness,
						RenderSize.Height + ( Padding * 2 ) - thickness,
						cornerRadius,
						cornerRadius );
					g.endFill();
				}
			}
		}

		public function get Thickness() : Number { return thickness; }
		public function set Thickness( value : Number ) : void { thickness = value; Invalidate(); }
		public function get StrokeColor() : uint { return strokeColor; }
		public function set StrokeColor( value : uint ) : void { strokeColor = value; Invalidate(); }
		public function get CornerRadius() : Number { return cornerRadius; }
		public function set CornerRadius( value : Number ) : void { cornerRadius = value; Invalidate(); }
	}
}