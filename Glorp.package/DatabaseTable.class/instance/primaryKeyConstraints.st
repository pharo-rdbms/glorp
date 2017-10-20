accessing
primaryKeyConstraints
	"Answer the value of the receiver's ''PrimaryKeyConstraints'' instance variable."
	^self hasPrimaryKeyConstraints
		ifTrue: [ PrimaryKeyConstraint forTable: self ]
		ifFalse: [ nil ]