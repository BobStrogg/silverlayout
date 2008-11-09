package com.chriscavanagh.Silverlayout.Controls
{
	import com.chriscavanagh.Silverlayout.*;
	import alducente.services.WebService;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Chris Cavanagh
	*/
	public class Grid extends FrameworkElement
	{
		private var orientation : String;
		private var rowDefinitions : Array;
		private var columnDefinitions : Array;

		private var rowSizes : Array;
		private var columnSizes : Array;

		public function Grid()
		{
			rowDefinitions = [];
			columnDefinitions = [];
		}

		public override function MeasureOverride( availableSize : Size ):Size 
		{
			if ( ( !this.rowDefinitions || this.rowDefinitions.length < 1 )
				&& ( !this.columnDefinitions || this.columnDefinitions.length < 1 ) )
			{
				return super.MeasureOverride( availableSize );
			}

			var rowDefinitions : Array = GetRowDefinitions();
			var columnDefinitions : Array = GetColumnDefinitions();
			var gridSize : Size = new Size( availableSize.Width, availableSize.Height );

			rowSizes = new Array( Math.max( 1, rowDefinitions.length ) );
			columnSizes = new Array( Math.max( 1, columnDefinitions.length ) );

			// Measure and subtract fixed rows
			for ( var rowIndex : int = 0; rowIndex < rowDefinitions.length; ++ rowIndex )
			{
				var row : RowDefinition = rowDefinitions[ rowIndex ] as RowDefinition;

				if ( !IsStretchHeight( row ) && !IsAutoHeight( row ) )
				{
					rowSizes[ rowIndex ] = row.Height;
					availableSize.Height = Math.max( 0, availableSize.Height - row.Height );
				}
			}

			// Measure and subtract fixed columns
			for ( var columnIndex : int = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
			{
				var column : ColumnDefinition = columnDefinitions[ columnIndex ] as ColumnDefinition;

				if ( !IsStretchWidth( column ) && !IsAutoWidth( column ) )
				{
					columnSizes[ columnIndex ] = column.Width;
					availableSize.Width = Math.max( 0, availableSize.Width - column.Width );
				}
			}

			// Measure auto rows & columns; subtract auto rows
			for ( rowIndex = 0; rowIndex < rowDefinitions.length; ++ rowIndex )
			{
				row = rowDefinitions[ rowIndex ] as RowDefinition;

				var rowSizeRemain : Size = new Size(
					availableSize.Width,
					IsAutoHeight( row ) || IsStretchHeight( row ) ? availableSize.Height : row.Height );

				for ( columnIndex = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
				{
					column = columnDefinitions[ columnIndex ] as ColumnDefinition;
					var columnWidth : Number = IsAutoWidth( column ) || IsStretchWidth( column ) ? rowSizeRemain.Width : column.Width;
					var cellSizeAvailable : Size = new Size( columnWidth, rowSizeRemain.Height );
					var cellSize : Size = MeasureCell( rowIndex, columnIndex, cellSizeAvailable );

					if ( IsAutoHeight( row ) ) rowSizes[ rowIndex ] = Math.max( Zero( rowSizes[ rowIndex ] ), cellSize.Height );

					if ( IsAutoWidth( column ) )
					{
						columnSizes[ columnIndex ] = Math.max( Zero( columnSizes[ columnIndex ] ), cellSize.Width );
						rowSizeRemain.Width = Math.max( 0, rowSizeRemain.Width - cellSize.Width );
					}
				}

				if ( IsAutoHeight( row ) ) availableSize.Height = Math.max( 0, availableSize.Height - Zero( rowSizes[ rowIndex ] ) );
			}

			// Subtract auto columns
			for ( columnIndex = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
			{
				column = columnDefinitions[ columnIndex ] as ColumnDefinition;

				if ( IsAutoWidth( column ) ) availableSize.Width = Math.max( 0, availableSize.Width - Zero( columnSizes[ columnIndex ] ) );
			}

			if ( VerticalAlignment != "Stretch" ) gridSize.Height = 0;

			// Measure and subtract stretch rows & columns
			for ( rowIndex = 0; rowIndex < rowDefinitions.length; ++ rowIndex )
			{
				row = rowDefinitions[ rowIndex ] as RowDefinition;
				rowSizeRemain = new Size( availableSize.Width, availableSize.Height );

				for ( columnIndex = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
				{
					column = columnDefinitions[ columnIndex ] as ColumnDefinition;

					if ( IsStretchHeight( row ) ) rowSizes[ rowIndex ] = Math.max( Zero( rowSizes[ rowIndex ] ), rowSizeRemain.Height );

					if ( IsStretchWidth( column ) )
					{
						columnSizes[ columnIndex ] = Math.max( Zero( columnSizes[ columnIndex ] ), rowSizeRemain.Width );
						rowSizeRemain.Width = Math.max( 0, rowSizeRemain.Width - Zero( columnSizes[ columnIndex ] ) );
					}
				}

				for ( columnIndex = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
				{
					MeasureCell( rowIndex, columnIndex, new Size( columnSizes[ columnIndex ], rowSizes[ rowIndex ] ) );
				}

				if ( IsStretchHeight( row ) ) availableSize.Height = Math.max( 0, availableSize.Height - Zero( rowSizes[ rowIndex ] ) );
				if ( VerticalAlignment != "Stretch" ) gridSize.Height += Zero( rowSizes[ rowIndex ] );
			}

			if ( HorizontalAlignment != "Stretch" )
			{
				gridSize.Width = 0;

				// Aggregate column widths
				for ( columnIndex = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
				{
					column = columnDefinitions[ columnIndex ] as ColumnDefinition;

					gridSize.Width += Zero( columnSizes[ columnIndex ] );
				}
			}

			return gridSize;
		}

		private function Zero( value : Number ) : Number
		{
			return value ? value : 0;
		}

		private function IsStretchWidth( column : ColumnDefinition ) : Boolean
		{
			return ( column.IsStretch && HorizontalAlignment == "Stretch" );
		}

		private function IsStretchHeight( row : RowDefinition ) : Boolean
		{
			return ( row.IsStretch && VerticalAlignment == "Stretch" );
		}

		private function IsAutoWidth( column : ColumnDefinition ) : Boolean
		{
			return column.IsAuto || ( column.IsStretch && HorizontalAlignment != "Stretch" );
		}

		private function IsAutoHeight( row : RowDefinition ) : Boolean
		{
			return row.IsAuto || ( row.IsStretch && VerticalAlignment != "Stretch" );
		}

		private function GetRowDefinitions() : Array
		{
			return ( rowDefinitions.length > 0 )
				? rowDefinitions
				: [ new RowDefinition( VerticalAlignment == "Stretch" ? null : "Auto" ) ];
		}

		private function GetColumnDefinitions() : Array
		{
			return ( columnDefinitions.length > 0 )
				? columnDefinitions
				: [ new ColumnDefinition( HorizontalAlignment == "Stretch" ? null : "Auto" ) ];
		}

		private function MeasureCell( rowIndex : int, columnIndex : int, availableSize : Size ) : Size
		{
			var size : Size = new Size();
			var children : Array = GetChildren( rowIndex, columnIndex );

			for ( var index : int = 0; index < children.length; ++ index )
			{
				var child : FrameworkElement = children[ index ] as FrameworkElement;

				if ( child != null )
				{
					var childSize : Size = child.Measure( availableSize );
					size = new Size(
						Math.max( size.Width, childSize.Width ),
						Math.max( size.Height, childSize.Height ) );
				}
			}

			return size;
		}

		private function GetChildren( rowIndex : int, columnIndex : int ) : Array
		{
			var children : Array = [];

			for ( var index : int = 0; index < numChildren; ++ index )
			{
				var child : FrameworkElement = getChildAt( index ) as FrameworkElement;

				if ( child != null && child.GridRow == rowIndex && child.GridColumn == columnIndex )
				{
					children.push( child );
				}
			}

			return children;
		}

		public override function ArrangeOverride( finalSize : Size ) : Size 
		{
			if ( ( !rowDefinitions || rowDefinitions.length < 1 )
				&& ( !columnDefinitions || columnDefinitions.length < 1 ) )
			{
				return super.ArrangeOverride( finalSize );
			}

			if ( rowSizes && columnSizes )
			{
				var rowDefinitions : Array = GetRowDefinitions();
				var columnDefinitions : Array = GetColumnDefinitions();
				var y : Number = 0;

				// Arrange rows and columns
				for ( var rowIndex : int = 0; rowIndex < rowDefinitions.length; ++ rowIndex )
				{
					var x : Number = 0;

					for ( var columnIndex : int = 0; columnIndex < columnDefinitions.length; ++ columnIndex )
					{
						var children : Array = GetChildren( rowIndex, columnIndex );

						for ( var index : int = 0; index < children.length; ++ index )
						{
							var child : FrameworkElement = children[ index ];
							var cellSize : Size = new Size( Zero( columnSizes[ columnIndex ] ), Zero( rowSizes[ rowIndex ] ) );

							var size : Size = child.Arrange( cellSize );

							var h : Extent = GetExtent( child.HorizontalAlignment, size.Width, cellSize.Width );
							var v : Extent = GetExtent( child.VerticalAlignment, size.Height, cellSize.Height );

							child.Offset = new Point( x + h.Offset, y + v.Offset );
						}

						x += Zero( columnSizes[ columnIndex ] );
					}

					y += Zero( rowSizes[ rowIndex ] );
				}
			}

			return finalSize;
		}

		public function AddColumn( column : ColumnDefinition ) : void
		{
			columnDefinitions.push( column );
			Invalidate();
		}

		public function AddRow( row : RowDefinition ) : void
		{
			rowDefinitions.push( row );
			Invalidate();
		}
	}
}