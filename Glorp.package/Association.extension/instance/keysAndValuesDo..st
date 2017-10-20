*Glorp
keysAndValuesDo: aBlock
	"A memory allocation hack. Let us use a single association in place of a dictionary"
	aBlock value: key value: value.