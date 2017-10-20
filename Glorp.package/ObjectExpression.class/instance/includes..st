internal
includes: anObject
	"Allow us to specify includes: as a shortcut for (anySatisfy: [:each | each = anObject]). Rather than just call anySatisfy:, we need to go through the get: mechanism, both to avoid the anySatisfy: method on expressions that treats them like a collection, and to make sure we get the default mechanism for anySatisfy: (either joins or exists)"
	^self get: #anySatisfy: withArguments: (Array with: ([:each | each = anObject] asGlorpExpressionOn: self)).