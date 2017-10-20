converting
sourceForTarget: aField

	| left |
	relation = #= ifFalse: [
		left := leftChild sourceForTarget: aField.
		left isNil ifFalse: [^left].
		^rightChild sourceForTarget: aField].
	rightChild field == aField ifTrue: [^leftChild field].
	leftChild field == aField ifTrue: [^rightChild field].
	^nil.