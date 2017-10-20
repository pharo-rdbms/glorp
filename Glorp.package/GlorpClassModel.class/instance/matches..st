validation
matches: anObject
	"Try to optimize this check as much as possible. We cache the list of subclasses, and inline the check for isKindOf:"
	| theClass |
	theClass := anObject glorpRealObject class.
	describedClass == theClass ifTrue: [^true].
	nil == subclasses ifTrue: [^false].
	1 to: subclasses size do: [:i | theClass == (subclasses at: i)
		ifTrue: [^true]].
	^false