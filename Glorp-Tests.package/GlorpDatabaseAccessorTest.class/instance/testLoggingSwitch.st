tests
testLoggingSwitch
	| currentSetting accessor |
	currentSetting := DatabaseAccessor loggingEnabled.
	accessor := DatabaseAccessor new.
	[DatabaseAccessor loggingEnabled: true.
	self assert: accessor logging.
	DatabaseAccessor loggingEnabled: false.
	self deny: accessor logging.
	accessor logging: true.
	self assert: accessor logging.
	accessor logging: false.
	self deny: accessor logging.
	DatabaseAccessor loggingEnabled: true.
	self deny: accessor logging] ensure: [DatabaseAccessor loggingEnabled: currentSetting].