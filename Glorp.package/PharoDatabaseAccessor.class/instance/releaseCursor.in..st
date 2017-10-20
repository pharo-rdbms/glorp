executing
releaseCursor: aCursor in: aPreparedStatement
	"Release the cursor. We're trapping exceptions, so return true or false to indicate success/failure"
	aCursor isNil ifTrue: [^self].
	^[aCursor close. true] on: Dialect error do: [:ex | ex return: false].