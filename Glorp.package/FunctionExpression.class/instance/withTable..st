copying
withTable: aTable
	"For a function expression, we shouldn't need to do anything here. It will have already been rebuilt on a base that has aliases"
	^self.

"	| copy newBase |
	newBase := BaseExpression new.
	newBase descriptor: base descriptor.
	copy := self rebuildOn: newBase.
	copy fieldExpression setTable: aTable.
	^copy."