package be.ntdst.core 
{
	
	/**
	 * Abstract.as
	 * 
	 * Use <code>Abstract</code> to create an abstract class. If this class is initiated directly
	 * an IllegalOperationError is thrown. This forces developers to use it as a base class.
	 */
	
	import flash.errors.IllegalOperationError;
	 
	public class Abstract 
	{
	
		public static function enforce(instance:Object, type:Class) : void
        {
            if (instance.constructor == type)
            {
                throw new IllegalOperationError(type + " is an AbstractClass and needs to be overriden");
            }
        }
		
	}
	
}