package com.chriscavanagh.Silverlayout.Controls
{
	import com.chriscavanagh.Silverlayout.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Button extends Border
	{
		public function Button( text : String = null, textFormat : TextFormat = null )
		{
//			Thickness = 1;
//			StrokeColor = 0x505050;
			Background = 0xD0D0D0;
			CornerRadius = 20;
			Padding = 2;
			Opacity = 0.7;
			useHandCursor = true;
			buttonMode = true;
			addEventListener( MouseEvent.ROLL_OVER, function( event : Event ) : void { Opacity = 1; } );
			addEventListener( MouseEvent.ROLL_OUT, function( event : Event ) : void { Opacity = 0.7; } );

			if ( text )
			{
				var textBlock : TextBlock = new TextBlock( text, textFormat );
				textBlock.HorizontalAlignment = "Center";
				textBlock.VerticalAlignment = "Center";
				addChild( textBlock );
			}
		}
	}
}