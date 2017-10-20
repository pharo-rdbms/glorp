debugging
rows
	"This will extract all the rows and replace the internal stream with a regular stream on the rows. This is useful for debugging, but in real use rather destroys the purpose of the cursored stream"
	| rows |
	rows := cursor upToEnd.
	self releaseCursor.
	cursor := rows readStream.
	^rows