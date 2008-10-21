package com.chriscavanagh.Silverlayout.Controls
{
	import com.chriscavanagh.Silverlayout.*;
	import com.chriscavanagh.Silverlayout.Controls.ContentControl;
	import com.chriscavanagh.Silverlayout.Controls.StackPanel;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Slider extends FrameworkElement
	{
		public static var VALUECHANGED : String = "VALUECHANGED";

		private var bar : VolumeBar;
		private var slider : ContentControl;
		private var thumb : VolumeThumb;
		private var minimum : Number;
		private var maximum : Number;
		private var value : Number;

		public function Slider()
		{
			Height = 20;
			minimum = 0;
			maximum = 1;
			value = 0;

			bar = new VolumeBar();

			slider = new ContentControl( bar );
			slider.VerticalAlignment = "Center";
			slider.Padding = 5;
			slider.buttonMode = true;
			addChild( slider );

			var onClick : Function = function( event : MouseEvent ) : void
			{
				thumb.x = event.localX + 1;
				OnValueChanged( event.localX / event.target.width );
			};

			slider.addEventListener( MouseEvent.CLICK, onClick );

			thumb = CreateThumb();
			addChild( new ContentControl( thumb ) );
		}

		override protected function OnRenderOverride(event:Event):void 
		{
			super.OnRenderOverride(event);

			if ( bar && slider && slider.RenderSize ) bar.width = slider.RenderSize.Width;
		}

		private function CreateThumb() : VolumeThumb
		{
			var thumb : VolumeThumb = new VolumeThumb();
			thumb.width = 10;
			thumb.height = 20;
			thumb.x = 0;
			thumb.y = 1;
			thumb.buttonMode = true;

			var dragging : Boolean = false;
			var onStopDrag : Function;

			onStopDrag = function( event : MouseEvent ) : void
			{
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMove );
				stage.removeEventListener( MouseEvent.MOUSE_UP, onStopDrag );
				thumb.stopDrag();
				dragging = false;
			};

			var onStartDrag : Function = function( event : MouseEvent ) : void
			{
				stage.addEventListener( MouseEvent.MOUSE_MOVE, onMove );
				stage.addEventListener( MouseEvent.MOUSE_UP, onStopDrag );

				thumb.startDrag( false, new Rectangle( 0, thumb.y, slider.width, 0 ) );
				dragging = true;
			};

			var onMove : Function = function( event : MouseEvent ) : void
			{
				OnValueChanged( thumb.x / slider.width );
			};

			thumb.addEventListener( MouseEvent.MOUSE_DOWN, onStartDrag );

			return thumb;
		}

		private function OnValueChanged( value : Number ) : void
		{
			if ( value != this.value )
			{
				this.value = value;
				dispatchEvent( new Event( VALUECHANGED ) );
			}
		}

		public function get Minimum() : Number { return minimum; }
		public function set Minimum( value : Number ) : void { minimum = value; Invalidate(); }
		public function get Maximum() : Number { return maximum; }
		public function set Maximum( value : Number ) : void { maximum = value; Invalidate(); }
		public function get Value() : Number { return minimum + ( ( maximum - minimum ) * value ); }
		public function set Value( value : Number ) : void
		{
			this.value = ( value - minimum ) / ( maximum - minimum );
			thumb.x = slider.width * value;
			Invalidate();
		}
	}
}