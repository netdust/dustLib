package be.ntdst.util
{
    import flash.utils.*;

    public class ObjectPool 
	{
		private var queue : Array = [];
        private var list : Array = [];
        private var disposed : Boolean = false;

        private var _minSize : int;
        private var _maxSize : int;
		
        public var size : int = 0;
        public var timeout : int = 20 * 1000;
        public var maxQueue : int = 5000;

        public var create : Function;
        public var clean : Function;
        public var onQueue : Function;
        public var onTimeout : Function;
        public var length : int = 0;

       
        public function ObjectPool(create : Function, clean : Function = null, minSize : int = 50, maxSize : int = 200, onQueue : Function = null, onTimeout : Function = null) {
            this.create = create;
            this.clean = clean;
            this.onQueue = onQueue;
            this.onTimeout = onTimeout;
            this.minSize = minSize;
            this.maxSize = maxSize;
            
            for(var i : int = 0;i < minSize; i++) add();
        }

        public function add() : void {
            list[length++] = create();
            size++;
            
            if(length > _maxSize) _maxSize = length;
            
            if(queue.length > 0) {
                clearTimeout(queue.pop());
                if(onQueue != null) onQueue(list[--length]);
            }
        }

        public function set minSize(num : int) : void {
            _minSize = num;
            if(_minSize > _maxSize) _maxSize = _minSize;
            if(_maxSize < list.length) list.splice(_maxSize);
            size = list.length;
        }

        public function get minSize() : int {
            return _minSize;
        }

        public function set maxSize(num : int) : void {
            _maxSize = num;
            if(_maxSize < list.length) list.splice(_maxSize);
            size = list.length;
            if(_maxSize < _minSize) _minSize = _maxSize;
        }

        public function get maxSize() : int {
            return _maxSize;
        }

        public function get queued() : int {
            return queue.length;
        }

        public function checkOut() : * {
            if(length == 0) {
                if(size < maxSize) {
                    size++;
                    return create();
                } else if(queue.length < maxQueue) {
                    queue.unshift(setTimeout(onFail, timeout));
                    return null;
                }
            }
            
            return list[--length];
        }

        public function checkIn(item : *) : void {
            if(clean != null) clean(item);
            list[length++] = item;
            
            if(queue.length > 0) {
                clearTimeout(queue.pop());
                if(onQueue != null) onQueue(list[--length]);
            }
        }

        public function stopQueue() : void {
            for(var i : int = 0;i < queue.length; i++) clearTimeout(queue[i]);
            queue = [];
        }

        public function dispose() : void {
            if(disposed) return;
            
            disposed = true;
            
            stopQueue();
            
            create = null;
            clean = null;
            onQueue = null;
            onTimeout = null;
            queue = null;
            list = null;
        }

        private function onFail() : void {
            queue.pop();
            if(onTimeout != null) onTimeout();
        }
    }
}
