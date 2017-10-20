class lookup
smalltalkAssociationAt: aName ifAbsent: aBlock

	^ Smalltalk associationAt: aName asSymbol ifAbsent: aBlock