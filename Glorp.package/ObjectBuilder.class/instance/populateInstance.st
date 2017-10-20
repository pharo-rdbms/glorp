building objects
populateInstance
	| tracker |
	key isNil ifTrue: [^self].
	self instanceDescriptor populateObject: instance inBuilder: self.
	tracker := self session modificationTracker.
	tracker isNil ifFalse: [tracker track: instance].