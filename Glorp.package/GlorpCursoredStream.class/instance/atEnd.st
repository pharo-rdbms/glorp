testing
atEnd
	"Release ourselves fairly aggressively when we hit the end"
	| accessor |
	peekBuffer isNil ifFalse: [^false].
	rawPeekBuffer isNil ifFalse: [^false].
	cursor isNil ifTrue: [^true].
	"For test purposes, fabricate an accessor if we don't have one, it's not really needed for a non-db stream"
	accessor := self accessor isNil ifTrue: [DatabaseAccessor new] ifFalse: [self accessor].
	^([accessor isCursorAtEnd: cursor] on: Dialect error do: [:ex | databaseAccessor handleError: ex for: command])
		ifTrue:
			[self release.
			true]
		ifFalse: [	"We have to do this, because VA won't answer true to atEnd until we've read past end"
			self rawPeek isNil].