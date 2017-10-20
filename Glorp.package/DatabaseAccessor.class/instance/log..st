logging
log: aStringOrBlock
	"Log an arbitrary string"
	| string |
	self logging ifFalse: [^self].
	string := aStringOrBlock isString
		ifTrue: [aStringOrBlock]
		ifFalse: [aStringOrBlock value].
	string size > 4000 ifTrue: [string := string copyFrom: 1 to: 4000].
	Transcript
		cr;
		show: string.