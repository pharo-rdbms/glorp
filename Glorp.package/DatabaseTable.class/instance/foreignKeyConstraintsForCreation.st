accessing
foreignKeyConstraintsForCreation
	"Return the foreign key constraints that should actually be created in the database. Omit those that refer to imaginary tables"
	^foreignKeyConstraints select: [:each |
		each isImaginary not and: [each shouldCreateInDatabase]].