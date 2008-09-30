package com.chriscavanagh.Silverlayout
{
	
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Extent 
	{
		public var Offset : Number;
		public var Size : Number;

		public function Extent( offset : Number, size : Number )
		{
			this.Offset = offset;
			this.Size = size;
		}

		public function toString() : String 
		{
			return "{Offset:" + Offset + ",Size:" + Size + "}";
		}
	}
}