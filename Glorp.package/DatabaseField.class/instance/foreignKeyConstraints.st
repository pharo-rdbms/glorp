accessing
foreignKeyConstraints
	^self table foreignKeyConstraints select: [:each | each sourceFields includes: self].