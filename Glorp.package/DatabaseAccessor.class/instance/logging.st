logging
logging
	logging isNil ifTrue: [^self class loggingEnabled].
	^logging.