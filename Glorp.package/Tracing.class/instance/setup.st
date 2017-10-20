setup
setup
	"We have been put into a query. If we aren't to trace anything else, trace the base"
	retrievalExpressions isEmpty ifTrue: [
		allTracings addFirst: base.
		retrievalExpressions add: base].