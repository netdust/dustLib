
package be.ntdst.collections
{
 

    public 	class 		ObjectIterator 
			implements 	Iterator
    {
        
        private var _a:Array;		
        private var items:Object;
		private var index:int = -1;		
            		
        public function ObjectIterator(o:Object)
        {
            items = o;
            _a = new Array();
            index = -1 ;
            var value:* ;
            for (var each:String in items)
            {
                value = o[each];
                if ( !(value is Function) ) 
                {    
                    _a.push(each);
                }
            } 
        };
   
        public function hasNext():Boolean
        {
            return index <  (_a.length - 1);
        };

        public function next():*
        {
            return items[ _a[++index] ];
        };
		
		public function prev():*
        {
            return items[ _a[--index] ];
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