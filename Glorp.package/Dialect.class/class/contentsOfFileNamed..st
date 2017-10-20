files
contentsOfFileNamed: aString
	"Given a text file name, read its contents"

	| stream contents |
	stream := (Dialect smalltalkAt: #MultiByteFileStream) oldFileNamed: aString.
	[ contents := stream contents ]
		ensure: [ stream close ].
	^ contents