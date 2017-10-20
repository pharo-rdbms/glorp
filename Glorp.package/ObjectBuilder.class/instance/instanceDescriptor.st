building objects
instanceDescriptor
	"Return the descriptor for the instance we're going to build. Note that we have to look it up by instance in order to find subclass. "
	| basicDescriptor |
	instance isNil ifTrue: [^nil].
	basicDescriptor := self system descriptorFor: instance.
	basicDescriptor isNil ifFalse: [^basicDescriptor].
	^expression descriptor.