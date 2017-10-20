accessing
commands
	commands isNil ifTrue: [commands := query queries collect: [:each | each sqlWith: parameters]].
	^commands.