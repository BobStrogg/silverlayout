package com.chriscavanagh.Silverlayout.Controls
{
	import com.chriscavanagh.Silverlayout.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Chris Cavanagh
	 */
	public class MediaElement extends FrameworkElement
	{
		private var player : VideoPlayer;

		public function MediaElement( player : VideoPlayer )
		{
			this.player = player;
			addChild( player );

			player.addEventListener( VideoPlayer.METADATA, function( event : Event ) : void { Invalidate(); } );
		}

		override public function MeasureOverride( availableSize : Size ) : Size 
		{
			var availableAspect : Number = availableSize.Width / availableSize.Height;

			return ( availableAspect <= player.AspectRatio )
				? new Size( availableSize.Width, availableSize.Width / player.AspectRatio )
				: new Size( availableSize.Height * player.AspectRatio, availableSize.Height );
		}

		override public function ArrangeOverride(finalSize:Size):Size 
		{
			player.width = MeasuredSize.Width;
			player.height = MeasuredSize.Height;

			return super.ArrangeOverride(finalSize);
		}
	}
}