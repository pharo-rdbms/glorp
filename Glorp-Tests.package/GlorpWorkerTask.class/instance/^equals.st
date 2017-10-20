comparing
= aTask

	self class = aTask class ifFalse:  [ ^false ].
	self id = aTask id ifFalse: [^false].
	self description = aTask description ifFalse: [^false].
	^true