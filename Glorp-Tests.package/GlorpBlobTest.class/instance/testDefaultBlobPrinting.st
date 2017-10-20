tests
testDefaultBlobPrinting
	"Test out default (SQL-92 syntax) byte array printing"
	| stream |
	stream := WriteStream on: String new.
	type := type copy.
	type platform: DatabasePlatform new.
	type print: (ByteArray with: 0) on: stream.
	self assert: stream contents = 'X''00'''.
	stream reset.
	type print: (ByteArray with: 16rFF) on: stream.
	self assert: stream contents = 'X''FF'''.
	stream reset.
	type print: (ByteArray with: 16r47) on: stream.
	self assert: stream contents = 'X''47'''.
	stream reset.
	type print: (ByteArray withAll: #(1 2 16rFE)) asByteArray on: stream.
	self assert: stream contents = 'X''0102FE'''.