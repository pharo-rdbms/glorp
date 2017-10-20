internal
performSpecialExpression: aSymbol withArguments: anArray
	| symbolToPerform |
	symbolToPerform := self specialSymbolToPerformFor: aSymbol.
	(self zeroArgumentSpecialSelectors includes: symbolToPerform) ifTrue: [^self perform: symbolToPerform].
	(self oneArgumentSpecialSelectors includes: symbolToPerform) ifTrue: [^self perform: symbolToPerform with: anArray first ].
	(self twoArgumentSpecialSelectors includes: symbolToPerform) ifTrue: [^self perform: symbolToPerform with: (anArray at: 1) with: (anArray at: 2)].
	^nil.