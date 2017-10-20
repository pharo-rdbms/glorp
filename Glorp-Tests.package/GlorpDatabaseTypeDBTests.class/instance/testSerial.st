tests
testSerial
	"type := PGSerialType instance.
	self assert: false.

	self assert: (type typeString = 'SERIAL')"