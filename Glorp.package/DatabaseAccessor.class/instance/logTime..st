logging
logTime: aTimeOrBlock
	| time |
	self changed: #time: with: aTimeOrBlock.
	self logging ifFalse: [^self].
	time := (Dialect isBlock: aTimeOrBlock)
		ifTrue: [aTimeOrBlock value]
		ifFalse: [aTimeOrBlock].
	Transcript
		cr;
		show: '(' , (time / 1000.0) printString , ' s)'.