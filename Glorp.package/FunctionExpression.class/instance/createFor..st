copying
createFor: arguments
	| new |
	new := self copy.
	new arguments: arguments.
	new type: type.
	^new.