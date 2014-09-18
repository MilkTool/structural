package structural;


/**
    Copyright 2014 Sven Bergström
    A simple cacheable pool type with on create callback

    Part of the structural library for haxe
    http://github.com/underscorediscovery/structural

    MIT license
*/

class Pool<T> {

        /** The size of the pool */
    public var length : Int = 0;
        /** The items in the pool */
    public var items : Array<T>;
        /** The current index in the pool*/
    public var index : Int = 0;

    var precache : Bool = true;
    var _create : Int -> Int -> T;

        /** Create a new pool with fixed size, on_create callback and cache flag. By default precache sis true. */
    public function new( pool_size:Int, create_callback:Int->Int->T, _precache:Bool = true ){

        length = pool_size;
        precache = _precache;
        items = [];
        _create = create_callback;

        if(precache) {
            for(i in 0 ... length) {
                items.push( _create(i, length) );
            }
        } //if precache

    } //new

        /** get the next available item from the pool, creating if needed, or from the cache. If the pool max has been reached the pool will wrap around to the oldest item in the pool. */
    public function get() : T {

            //we want to make sure that we are creating items that don't exist to the max
        if(!precache && items.length < length) {
                //need to add a new one, so request it
            items.push( _create(index, length) );
        }

        var _item = items[index];

            //after, increase the index, so that the index is always
            //on the next free one. In other words list[index] is the next one, not the last used one
        index++;
        if(index > length-1) {
            index = 0;
        }

        return _item;

    } //get


} //Pool