mapping
reverseMapping
	"Construct the backwards mapping that corresponds to us. If it's using a link table, then we are at least potentially a toMany mapping. Otherwise, we can point backwards only to a single object."
	| mapping |
	^self usesLinkTable
		ifTrue: 
			[mapping := (ManyToManyMapping new)
				attributeName: #temporaryAttributeFromSubselect;
				referenceClass: self descriptor describedClass;
				join: self reverseJoin inverseJoin;
				descriptor: self descriptor.
			mapping reverseJoin: self join inverseJoin onlyJoinParts]
		ifFalse: 
			[(OneToOneMapping new)
				attributeName: #temporaryAttributeFromSubselect;
				referenceClass: self descriptor describedClass;
				join: self join inverseJoin;
				descriptor: self descriptor]