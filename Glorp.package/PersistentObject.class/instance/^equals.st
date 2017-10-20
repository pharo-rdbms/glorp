comparing
= anObject
	"Implement equality to compare primary keys if they are set. Make sure that if we have proxies, we check through them."

	| descriptor myKey |
	self class = anObject yourSelf class ifFalse: [^false].
	descriptor := self descriptor.	

	"If the primary keys aren't equal, then we know for sure we are unequal. Otherwise we have to check further."
	myKey := descriptor primaryKeyCollectionFor: self.
	myKey = (descriptor primaryKeyCollectionFor: anObject)
		ifFalse: [^false].

	"If the primary key contains nils, then fall back to the default equality comparison. If they don't, and are equal, then the objects are equal."
	^(myKey includes: nil) 
		ifTrue: [super = anObject yourSelf]
		ifFalse: [true].