tests
testDecimal
	"Decimals aren't guaranteed to be exact (the fraction may be different) so use the float helper"

	self helpTestFloat: nil.
	self helpTestValue: 3.1415s4 compareWith: [:read :original |
		(read - original) abs <= 0.00001].