private
directGetValueFrom: anObject 
	| index |
	index := self instVarIndexIn: anObject.
	index = 0 ifTrue: [self raiseInvalidAttributeError].
	^anObject instVarAt: index