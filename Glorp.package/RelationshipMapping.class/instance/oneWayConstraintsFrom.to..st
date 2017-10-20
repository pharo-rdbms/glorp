initializing
oneWayConstraintsFrom: oneTableSet to: anotherTableSet
	| matches |
	matches := OrderedCollection new: 3.
	oneTableSet do: [:eachFromTable |
		 anotherTableSet do: [:eachToTable |
			matches addAll:  (eachFromTable foreignKeyConstraints
					select: [:eachConstraint | eachConstraint refersToTable: eachToTable])]].
	^matches.