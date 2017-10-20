accessing
mightHaveDuplicateRows
	mightHaveDuplicateRows isNil ifTrue: [mightHaveDuplicateRows := self query isNil ifTrue: [false] ifFalse: [self query mightHaveDuplicateRows]].
	^mightHaveDuplicateRows.