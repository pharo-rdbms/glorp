mapping
referencedIndependentObjectsFrom: anObject
	"Assumes that the only object this might affect is our primary attribute. That's probably valid. I think."
	| object otherDescriptor |
	object := self getValueFrom: anObject.
	(object isGlorpProxy and: [object isInstantiated not]) ifTrue: [^#()].
	otherDescriptor := self system descriptorFor: object.
	^otherDescriptor isNil ifTrue: [#()] ifFalse: [Array with: object]