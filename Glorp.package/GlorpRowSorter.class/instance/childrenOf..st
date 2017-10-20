sorting
childrenOf: anItem
	^childCache at: anItem ifAbsentPut: [
		childSelector isSymbol
			ifTrue: [anItem perform: childSelector]
			ifFalse: [childSelector value: anItem]].