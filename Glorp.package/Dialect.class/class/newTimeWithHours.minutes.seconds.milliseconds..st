dates
newTimeWithHours: hours minutes: minutes seconds: seconds milliseconds: milliseconds

	^ Time fromSeconds: hours * 60 * 60 + (minutes * 60) + (milliseconds / 10000)