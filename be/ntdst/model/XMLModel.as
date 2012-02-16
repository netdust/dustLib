package be.ntdst.model 
{
	import flash.utils.*;
	
	import be.ntdst.core.*;
	import be.ntdst.util.log.*;
	
	
	public 	class	XMLModel 
			extends Model
	{
	
		private var _map:Dictionary;
    
		public override function set data(m:*):void {
			parse( m as XML );
			super.data = m;			
		};
		
		public override function get data():* {
			return ( super.data as XML );
		};
		
		public function XMLModel( _sId:String ) 
		{
			Abstract.enforce( this, XMLModel );					
			super( _sId );
		};
		
		override public function find( key:* ):* {
			if ( key == '' ) return data;
			return _map[key];
		}
		
        private function parse( xml:XML = null ):void
        {
			_map = new Dictionary(true);
			var xmlhash:Object = new Object();
            var variables:XMLList = describeType(this).variable;
			
			if (xml)
            {
                for each (var attribute:XML in xml.attributes())
                {
                    xmlhash[attribute.name().toString()] = attribute.toString();
                }
                for each (var child:XML in xml.children())
                {
                    xmlhash[child.name()] = child;
                }
			}
			
            for (var key:String in xmlhash)
            {
                var varmatches:XMLList = variables.(@name == key);
                var value:* = xmlhash[key];				
		
                if (varmatches && varmatches.length() == 1)
                {
                    var type:String = varmatches[0].@type;
										
					try {
						this["parse_" + type.toLocaleLowerCase()].apply( this, [key, type=="XML" ? value:value.text().toString()] );
					}
					catch ( e:Error ) {
						Logger.warn("Couldn't interpret the value from XML into the requested type, " + type);
					}                 
					
                }
            }
        };
		
		private function parse_xml( key:String, value:* ) :void 
		{
            _map[key] = value;
		}
		
		private function parse_array( key:String, value:* ) :void 
		{
			value = value.replace(/^\[/,"").replace(/\]$/,"");
            _map[key] = value.split(/\s*,\s*/);
		};
		
		private function parse_string( key:String, value:* ) :void 
		{
			_map[key] = value;
		};
		
		private function parse_number( key:String, value:* ) :void 
		{
			_map[key] = parseFloat(value);
		};
		
		private function parse_int( key:String, value:* ) :void 
		{
			var match:Object = (/^(0x|#)([a-fA-F0-9]+)/).exec(value);
            if (match)
            {
                _map[key] = parseInt(match[2], 16);
            } else {
                _map[key] = parseInt(value);
            }
		};
		
		private function parse_uint( key:String, value:* ) :void 
		{
			parse_int( key, value );
		};
		
	}
	
}