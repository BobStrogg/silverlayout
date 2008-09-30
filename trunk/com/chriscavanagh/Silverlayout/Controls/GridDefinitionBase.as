package com.chriscavanagh.Silverlayout.Controls
{
	/**
	 * ...
	 * @author Chris Cavanagh
	 */
	public class GridDefinitionBase
	{
		protected var size : *;

		public function GridDefinitionBase( size : * = null )
		{
			this.size = size;
		}

		public function get IsAuto() : Boolean { return ( size == "Auto" ); }
		public function get IsStretch() : Boolean { return ( !size || size == "*" ); }
	}	
}