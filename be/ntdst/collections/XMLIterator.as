package be.ntdst.collections 
{
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 */
	public 	class 		XMLIterator
			implements 	Iterator
	{
	
        private var items:XMLList;
		private var index:int = -1;		
		
		public function XMLIterator(o:XML) 
		{
			items = o.children();
		}
		
		public function hasNext():Boolean
        {
            return index <  (items.length() - 1);
        };

        public function next():*
        {
            return items[ ++index ];
        };
		
		public function prev():*
        {
            return items[ --index ];
        };

		public function position():int
        {
            return index ;
        };
		
        public function reset():void
        {
            index = -1;
        };
		
	}

}