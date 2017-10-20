class lookup
smalltalkAssociationAt: aName

	^ self smalltalkAssociationAt: aName ifAbsent: [self error: 'element not found']