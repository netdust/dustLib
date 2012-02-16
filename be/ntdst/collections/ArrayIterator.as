

 package be.ntdst.collections
{

    public 	class 		ArrayIterator 
			implements 	Iterator
    {

        private var items:Array;
        private var index:int = 0;

        public function ArrayIterator(array:Array = null)
        {
            items = array;
        };

        public function hasNext() : Boolean
        {
            return index < items.length;
        };

        public function next() : *
        {
            return items[index++];
        };
		
		public function prev() : *
        {
            return items[index--];
        };

		public function position() : int
        {
            return index;
        };
		
        public function reset() : void
        {
            index = 0;
        };

       
    }
}
