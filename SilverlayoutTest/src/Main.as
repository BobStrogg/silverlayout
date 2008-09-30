package 
{
	import com.chriscavanagh.Silverlayout.*;
	import com.chriscavanagh.Silverlayout.Controls.*;
	import com.chriscavanagh.Silverlayout.Controls.Primitives.*;
	import com.chriscavanagh.Silverlayout.Documents.*;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextFormat;

	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Chris Cavanagh
	 */
	public class Main extends Sprite 
	{
		private var textFormat : TextFormat = new TextFormat( "Arial", 16, 0x0000FF );
		private var layoutContainer : FrameworkElement;

		public function Main():void 
		{
			layoutContainer = new FrameworkElement();
			layoutContainer.Padding = 10;
			layoutContainer.Background = 0xD0D0FF;
			addChild( layoutContainer );

			// Add some TextBlocks
			layoutContainer.addChild( CreateTextBlock( "Top left", "Top", "Left" ) );
			layoutContainer.addChild( CreateTextBlock( "Top right", "Top", "Right" ) );
			layoutContainer.addChild( CreateTextBlock( "Bottom right", "Bottom", "Right" ) );
			layoutContainer.addChild( CreateTextBlock( "Bottom left", "Bottom", "Left" ) );

			// Add a StackPanel
			var stackPanel : StackPanel = new StackPanel();
			stackPanel.HorizontalAlignment = "Center";
			stackPanel.VerticalAlignment = "Center";
			stackPanel.Width = 300;
			layoutContainer.addChild( stackPanel );

			stackPanel.addChild( CreateTextBlock( "A line of wrapping text in a centered StackPanel #1" ) );
			stackPanel.addChild( CreateTextBlock( "A line of wrapping text in a centered StackPanel #2" ) );
			stackPanel.addChild( CreateTextBlock( "A line of wrapping text in a centered StackPanel #3" ) );

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE, onResize );

			onResize( null );
		}

		private function CreateTextBlock( text : String, vAlign : String = "Center", hAlign : String = "Center" ) : TextBlock
		{
			var tb : TextBlock = new TextBlock( text, textFormat );
			tb.EmbedFonts = false;
			tb.VerticalAlignment = vAlign;
			tb.HorizontalAlignment = hAlign;
			return tb;
		}

		private function onResize( event : Event ) : void
		{
			layoutContainer.Width = stage.stageWidth;
			layoutContainer.Height = stage.stageHeight;
		}
	}
}