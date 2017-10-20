tests
testReadEmpty
	stream := GlorpCursoredStream on: (ReadStream on: #()) for: (stream query sqlWith: #()).
	self assert: stream atEnd.
	self assert: stream next isNil.