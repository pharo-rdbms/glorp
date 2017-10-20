tests
testDate

	| date |
	date := Date today.
	stType := Date.

	self helpTestValue: date.
	self helpTestValue: nil.