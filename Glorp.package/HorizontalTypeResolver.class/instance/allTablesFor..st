accessing
allTablesFor: aDescriptor
	"Return all tables used by this descriptor or its subclasses."
	^(self descriptorsRequiringIndependentQueriesFor: aDescriptor describedClass) inject: OrderedCollection new into: [:sum :eachDescriptor |
		sum addAll: ((eachDescriptor == aDescriptor) ifTrue: [eachDescriptor tables] ifFalse: [eachDescriptor allTables]).
		sum]