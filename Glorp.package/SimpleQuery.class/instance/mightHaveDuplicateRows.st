testing
mightHaveDuplicateRows

	^builders anySatisfy: [:each | each canCauseDuplicateRows]