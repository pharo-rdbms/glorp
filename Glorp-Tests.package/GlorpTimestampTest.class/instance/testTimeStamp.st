tests
testTimeStamp
	"This has to be UTC because postgres has time zones and will try and compensate"

	| time |
	time := Dialect timestampNow.
	self helpTestValue: nil.
	self
		helpTestValue: time
		compareWith:
			[:read :original | 
			"MS SQL Server fails randomly because it has a resolution of 3 ms only."
			"GNU Smalltalk seems to be quite lone in following the ANSI standard..."
			self compareTime: read to: original].