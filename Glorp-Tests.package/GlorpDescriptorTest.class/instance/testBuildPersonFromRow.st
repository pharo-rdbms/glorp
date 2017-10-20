tests
testBuildPersonFromRow
	| descriptor object address session builder |
	session := GlorpMockSession new.
	session system: system.
	address := GlorpAddress new.
	session cacheAt: 127 put: address.
	descriptor := system descriptorFor: GlorpPerson.
	system tableNamed: 'PERSON'.
	object := GlorpPerson new.
	builder := ObjectBuilder new.
	builder row: #(456 'Ralph' 127).
	descriptor populateObject: object inBuilder: builder.
	self assert: object class = GlorpPerson.
	self assert: object id = 456.
	self assert: object name = 'Ralph'.
	self assert: object address getValue == address.