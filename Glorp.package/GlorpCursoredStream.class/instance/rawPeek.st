private
rawPeek
	"Peek at the underlying rows, but don't build objects"
	rawPeekBuffer isNil ifFalse: [^rawPeekBuffer].
	rawPeekBuffer := cursor next.
	^rawPeekBuffer.