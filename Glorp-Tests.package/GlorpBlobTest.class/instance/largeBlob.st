tests
largeBlob
	"Make a significant sized blob. 64k+ a bit should do"
	| blobStream |
	blobStream := WriteStream on: (ByteArray new: 10000).
	(((2 raisedTo: 16) + 100.0) / 255.0) ceiling timesRepeat: [
		blobStream nextPutAll: self blob255].
	^blobStream contents.