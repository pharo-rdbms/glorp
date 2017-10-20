executing
createTableFKConstraints: aGLORBDatabaseTable ifError: aBlock 
	"This method should be used to define foreign key constraints for a database table from aTable"

	aGLORBDatabaseTable foreignKeyConstraintsForCreation
		do: [ :each | self addConstraint: each ifError: aBlock ].