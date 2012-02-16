package be.ntdst.util.log {

    public interface LoggerTarget {
        function publish(level:String, path:String, obj:*):void;
    }
}
