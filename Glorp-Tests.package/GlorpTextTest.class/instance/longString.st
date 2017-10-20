tests
longString
	"Make a significant sized stringlob. 64k+ a bit should do"
	| stream |
	stream := WriteStream on: (String new: 10000).
	(((2 raisedTo: 16) + 100.0) / 255.0) ceiling timesRepeat: [
		stream nextPutAll: self string255].
	^stream contents.