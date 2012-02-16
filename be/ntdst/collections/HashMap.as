

package be.ntdst.collections
{
    import flash.utils.Dictionary;
    
    public class HashMap 
    {

        protected var map:Dictionary;
        
   
        public function HashMap(useWeakReferences:Boolean = true)
        {
            map = new Dictionary( useWeakReferences );
        };

		public function remove(key:*) : void
        {
            delete map[key];
        };
		
        public function put(key:*, value:*) : void
        {
            map[key] = value;
        };
		
		public function get(key:*) : *
        {
            return map[key];
        };      
 
        public function containsKey(key:*) : Boolean
        {
            return map[ key ] != undefined;
        };

        public function containsValue(value:*) : Boolean
        {
            var result:Boolean = false;

            for ( var key:* in map )
            {
                if ( map[key] == value )
                {
                    result = true;
                    break;
                }
            }
            return result;
        };
 
        public function getKey(value:*) : *
        {
            var id:* = null;

            for ( var key:* in map )
            {
                if ( map[key] == value )
                {
                    id = key;
                    break;
                }
            }
            return id;
        };

        public function getValue(key:*) : *
        {
            return map[key];
        };		
		
        public function size() : int
        {
            var length:int = 0;

            for (var key:* in map)
            {
                length++;
            }
            return length;
        };


        public function isEmpty() : Boolean
        {
            return size() <= 0;
        };

        public function clear() : void
        {
            for ( var key:* in map )
            {
                remove( key );
            }
        };
 
    }
}
