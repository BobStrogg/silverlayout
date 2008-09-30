package com.chriscavanagh.Silverlayout.Controls
{
	/**
	 * ...
	 * @author Chris Cavanagh
	 */
	public class ColumnDefinition extends GridDefinitionBase
	{
		public function ColumnDefinition( width : * = null )
		{
			super( width );
		}

		public function get Width() : * { return size; }
		public function set Width( value : * ) : void { size = value; }
	}	
}