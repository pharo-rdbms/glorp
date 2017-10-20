This is a an abstract superclass for the protocol 2 and protocol 3 APIs of the open-source PostgreSQL database.

This supports binding but has it off by default.  To change this generally, implement (class-side) useBindingByDefault to return true for it or a subclass.  To change it (for all platforms) in a given image, set
	Glorp.DatabasePlatform.UseBindingIfSupported := true
In either case check already-assigned values of any existing platform instances after changing.
