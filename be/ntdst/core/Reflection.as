package be.ntdst.core 
{
	
	/**
	 * ...
	 * @author Stefan Vandermeulen
	 * 
	 * create class from string defintion; package must be imported for this to work!
	 * 
	 * @example
	 * var clss:Class = Reflection.getType( 'be.ntdst.view.SomeView' );
	 * var view:View = new clss( 'view_id' );
	 * 
	 */
	public class Reflection 
	{
		
		import flash.utils.getDefinitionByName;

		public static function getType(type:String) : Class
        {
            try {
                var ClassReference:Class = getDefinitionByName(type) as Class;
            }
            catch (error:Error)
            {
                throw new TypeError( type );
            }

            return ClassReference;
        }
	}
	
}