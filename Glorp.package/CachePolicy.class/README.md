A CachePolicy implements the different possible policies we might use for caching. The superclass implements the trivial policy of keeping all objects forever.

The policy also controls what we store in the cache. In general, it's assumed to be a cache entry of some sort, and the policy is responsible for wrapping and unwrapping objects going to and from the cache. The default policy is that the objects themselves are the cache entry (saving one object per cached object in overhead).

Instance Variables
	size	<Number>	The minimum cache size we want to use.
	expiryAction <Symbol> What to do when an object has expired. Currently hard-coded as one of #remove, #notify, #refresh, #notifyAndRemove.
