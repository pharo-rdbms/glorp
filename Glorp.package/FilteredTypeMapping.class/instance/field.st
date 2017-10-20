accessing
field
	"If we don't have this, look it up from one of our sub-mappings"
	| concrete |
	field isNil ifTrue: [
		concrete := self descriptor typeResolver concreteMembers detect: [:each | each typeMapping field notNil].
		field := concrete typeMapping field].
	^field.