mapping
pseudoDescriptor
	"Return a pretend descriptor for our reference class. Since that class is a primitive, it won't have a real descriptor, and it may vary by usage anyway"
	| pseudoDescriptor |
	pseudoDescriptor := Descriptor new.
	pseudoDescriptor system: descriptor system.
	^pseudoDescriptor