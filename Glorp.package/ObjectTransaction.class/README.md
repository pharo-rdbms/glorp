An ObjectTransaction knows how to remember the state of objects and revert them back to that state later on. It does this by making a *shallow* copy of the registered objects and everything connected to them, and then putting that into an identity dictionary keyed by the originals.

If you have to undo, you push the state from the shallow copies back into the originals.

Yes, that works, and it's all you have to do. It even handles collections become:ing different sizes.

This is fairly independent of GLORP. You could use this mechanism in general, if you provided your own mechanism for figuring out what to register, or even just uncommented the one in here.

Instance Variables:
	undoMap	<IdentityDictionary>	 The dictionary of originals->copies.

