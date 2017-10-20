debugging
displayString
	"For use in by-hand debugging.  For more general use if the dialect has a #displayString implementation in Object that returns printString.  (If everything else is nil, we assume the receiver is too and we're the result of a
	MessageArchiver new
call at the base of the expression, but we print the receiver uppercase, both to distinguish this base case from any other nil and just in case it is not nil.)"

	| str |
	query isNil ifFalse: [^query printString].
	(mySelector isNil and: [myArguments isNil]) ifTrue:
		[^myReceiver displayString asUppercase].
	(str := (String new: 64) writeStream)
		nextPutAll: myReceiver displayString;
		space;
		nextPutAll: mySelector.
	myArguments do:
		[:each |
		str crtab; nextPutAll:
			(each displayString
				copyReplaceAll: (Array with: Character cr)
				with: (Array with: Character cr with: Character tab))].
	^str contents