comparing
hash
	"Implement hash to compare primary keys if they are set. Make sure that if we have proxies, we check through them."

	| myKey |

	"If the primary key contains nils, then fall back to the default hash. If they don't, hash the collection."
	myKey := self descriptor primaryKeyCollectionFor: self.
	^(myKey includes: nil) 
		ifTrue: [super hash]
		ifFalse: [myKey hash]