package com.chriscavanagh.Silverlayout.Documents
{
	import com.chriscavanagh.Silverlayout.*;
	import com.chriscavanagh.Silverlayout.Controls.TextBlock;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Hyperlink extends FrameworkElement
	{
		public var OnHighlight : Function;
		private var textFormat : TextFormat;
		private var highlightTextFormat : TextFormat;
		private var onClick : Function;

		public function Hyperlink( text : String = null, textFormat : TextFormat = null, highlightTextFormat : TextFormat = null, onClick : Function = null )
		{
			this.textFormat = textFormat;
			this.highlightTextFormat = highlightTextFormat;
			this.onClick = onClick;

			OnHighlight = ApplyFormat;

			HorizontalAlignment = "Left";
			VerticalAlignment = "Top";
			useHandCursor = true;
			buttonMode = true;
			addEventListener( MouseEvent.ROLL_OVER, function( event : Event ) : void { SetHighlight( true ); } );
			addEventListener( MouseEvent.ROLL_OUT, function( event : Event ) : void { SetHighlight( false ); } );
			addEventListener( MouseEvent.CLICK, OnClick );

			if ( text )
			{
				var textBlock : TextBlock = new TextBlock( text, textFormat );
				textBlock.HorizontalAlignment = "Center";
				textBlock.VerticalAlignment = "Center";
				addChild( textBlock );
			}
		}

		private function OnClick( event : Event ) : void
		{
			if ( onClick != null ) onClick( event );
		}

		public function SetHighlight( on : Boolean ) : void
		{
			for ( var index : int = 0; index < numChildren; ++ index )
			{
				if ( OnHighlight != null ) OnHighlight( getChildAt( index ), on );
			}
		}

		public function ApplyFormat( element : * , on : Boolean ) : void
		{
			var format : TextFormat = on ? highlightTextFormat : textFormat;
			if ( element is TextBlock ) ( element as TextBlock ).TextFormat = format;
		}
	}
}