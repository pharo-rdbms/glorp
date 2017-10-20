initializing
constraintsFrom: oneTableSet to: anotherTableSet
	^(self oneWayConstraintsFrom: oneTableSet to: anotherTableSet), 
		(self oneWayConstraintsFrom: anotherTableSet to: oneTableSet)