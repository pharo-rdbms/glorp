api
referencedIndependentObjectsFrom: anObject

	| value |
	self canWrite ifFalse: [^#()].
	value := self getValueFrom: anObject.
	value == nil ifTrue: [^#()].
	^Array with: value.