accessing
name
	name isNil ifTrue: [^self connectString] ifFalse: [^name].