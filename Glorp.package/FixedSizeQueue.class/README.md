This is a fixed size queue of objects. It's intended for keeping around a fixed number of references to objects in a weak dictionary. As such its API is rather limited (one method), and it's write-only.

Instance Variables:
	items	<OrderedCollection>	The items in the queue
	maximumSize	<Integer>	How many items we're allowed