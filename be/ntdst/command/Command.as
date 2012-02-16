package be.ntdst.command {
	import flash.events.Event;

    public interface Command {
        function execute(evt:Event=null) :void;
    }
}
