accessing
primaryKey

	| |
	self table primaryKeyFields isEmpty ifTrue: [^nil].
	^self table hasCompositePrimaryKey 
		ifTrue: [
			self table primaryKeyFields 
				collect: [:each | 	self at: each]]
		ifFalse: [self at: self table primaryKeyFields first ifAbsent: [nil]].