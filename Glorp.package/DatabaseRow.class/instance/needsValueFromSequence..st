sequencing
needsValueFromSequence: aSequence 
	self table fields do: 
			[:each | 
			((self shouldGenerateValueFor: each) and: [each type sequence == aSequence]) 
				ifTrue: [^true]].
	^false