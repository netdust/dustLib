

 package be.ntdst.collections
 {

    public interface Iterator
    {
       function hasNext() : Boolean;
       function next() : *;
       function reset() : void;
       function position() : int;
   }
}
