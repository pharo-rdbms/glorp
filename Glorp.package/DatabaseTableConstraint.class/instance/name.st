accessing
name
	name isNil ifTrue: [name := self generateName].
	^name.