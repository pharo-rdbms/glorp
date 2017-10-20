private/mapping
originalValueFor: anObject mapping: eachMapping
	| memento |
	memento := transaction undoMap at: anObject.
	^eachMapping getValueFrom: memento