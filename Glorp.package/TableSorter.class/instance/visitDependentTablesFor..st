sorting
visitDependentTablesFor: aTable 
	aTable foreignKeyConstraints do: [:eachConstraint | 
          self visit: eachConstraint targetTable ]