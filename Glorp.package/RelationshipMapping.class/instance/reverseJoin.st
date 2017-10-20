mapping
reverseJoin

	reverseJoin isNil ifTrue: [reverseJoin := self joinFromLinkToReferenceTable].
	^reverseJoin.