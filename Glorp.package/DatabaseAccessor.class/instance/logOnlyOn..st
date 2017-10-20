logging
logOnlyOn: aTextCollector
	"logOnly implies you're logging and that you have a logger, so combine setting them into a single method (inverse is #endLogging)."

	self logger: aTextCollector.
	self logging: true.
	self logOnly: true.