accessing
targetTable
	"All the target fields have to come from the same table, so just pick one"
	^self targetFields isEmpty ifTrue: [nil] ifFalse: [self targetFields first table].