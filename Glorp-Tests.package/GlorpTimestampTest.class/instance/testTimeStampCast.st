tests
testTimeStampCast
	"SQLite does not have time-related types:  they are all mapped to strings.  I have not debugged why this test fails yet but assume it is completely unrealistic to expect a string to be cast to a timestamp."

	| timestamp model |
	
	Dialect isPharo ifTrue: [ ^ self skip: 'Pharo does not implement #cast:.' ].
	
	timestamp := Dialect timestampNow.
	"OraclePlatform>>timestamp returns the 'DATE' type;  casting to Oracle DATE loses all data below seconds.  We therefore truncate the timestamp to seconds in what is (or can be made in Glorp*Port) a dialect-neutral way."
	timestamp := timestamp class fromSeconds: timestamp asSeconds.
	session transact: [session register: (GlorpTypeTestsModelClass new test: timestamp)].
	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test cast: session platform timestamp) = timestamp].
	self deny: model isNil
		description: 'This test will fail on SQLite which has no DB Timestamp type;  see test comment'.
	self assert: (self compareTime: model test to: timestamp).
	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | (each test cast: session platform date) = timestamp].
	self deny: model isNil.
	self assert: (self compareTime: model test to: timestamp).

	model := session readOneOf: GlorpTypeTestsModelClass where: [:each | each test asTimestamp = timestamp].
	self deny: model isNil.
	self assert: (self compareTime: model test to: timestamp).