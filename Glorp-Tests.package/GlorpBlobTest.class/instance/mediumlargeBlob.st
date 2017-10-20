tests
mediumlargeBlob
	"Make a Blob just under 32K in size"
	"self new mediumlargeBlob"
	| blobStream |
	blobStream := WriteStream on: (ByteArray new: 10000).
	(((2 raisedTo: 15) - 600.0) / 255.0) ceiling timesRepeat: [
		blobStream nextPutAll: self blob255].
	^blobStream contents.