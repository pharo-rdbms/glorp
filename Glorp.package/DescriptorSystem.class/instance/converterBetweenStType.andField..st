private
converterBetweenStType: aClass andField: aField 
	| selector |
	selector := ('converterBetween' , aClass name , 'AndField:') asSymbol.
	(self respondsTo: selector) ifTrue: [^self perform: selector with: aField].
	^aField converterForStType: aClass