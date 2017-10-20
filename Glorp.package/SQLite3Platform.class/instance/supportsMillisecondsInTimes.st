constants
supportsMillisecondsInTimes
	"The only time-type-related functions in SQLite are CURRENT_TIME format HH:MM:SS and CURRENT_TIMESTAMP format YYYY-MM-DD HH:MM:SS, neither of which support milliseconds.  As against that, since we map to and from strings, we can easily include milliseconds in these strings.  For now, I go with the SQLite function choice and say no, but I have verified that tests work fine when I set this to true."

	^false