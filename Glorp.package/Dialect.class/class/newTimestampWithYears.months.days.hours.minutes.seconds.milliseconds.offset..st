dates
newTimestampWithYears: years
	months: months
	days: days
	hours: hours
	minutes: minutes
	seconds: seconds
	milliseconds: millis
	offset: offset

	^self timestampClass 
			year: years
			month: months
			day: days
			hour: hours
			minute: minutes
			second: seconds
			nanoSecond: millis * 1000000
			offset: (Duration seconds: offset)
