tests
testBuilderIsolation
	"Make sure that we can have multiple streams open simultaneously against the same query"
	| stream2 person1 stream3 person4 person4a |
	stream2 := GlorpCursoredStream on: self mockStream2 for: stream command.
	stream3 := GlorpCursoredStream on: self mockStream2 for: stream command.
	person1 := stream next.
	person4 := stream2 next.
	person4a := stream3 next.
	self assert: person4 == person4a.
	self assert: person4 id = 4.
	self assert: person1 id = 1.
	self assert: stream next id = 2.
	self assert: person4a id = 4.