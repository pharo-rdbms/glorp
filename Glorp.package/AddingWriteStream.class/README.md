Why *can't* you stream onto a set? Or a bag, or a SortedCollection? No good reason that I can see. This implements only a subset of stream behaviour, that which is necessary to let us build up collections where we have to "append" elements using #add: rather than #at:put: and explicit grows.

Instance Variables:
	target	<Collection>	The thing we're streaming onto.

