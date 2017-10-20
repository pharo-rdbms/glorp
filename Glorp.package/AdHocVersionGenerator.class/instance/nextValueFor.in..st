sequencing
nextValueFor: aField in: aRow
	"Get the next value by evaluating the block. If it doesn't care about the field or row, don't pass them as arguments. If it does, then give it both."
	numberOfArguments = 0 ifTrue: [^block value] ifFalse: [^block value: aField value: aRow].