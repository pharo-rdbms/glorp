type helpers
typesWithValues
	"Return our types list, but makes sure it has at least basic types in it"
	self varchar.
	self int4.
	self integer.
	self int.
	self number.
	self timestamp.
	self char.
	self blob.
	self clob.
	self raw.
	self serial.
	self text.
	^self types.