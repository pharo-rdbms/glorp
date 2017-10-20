preparing
fixJoins
	| pseudoJoins realJoins |
	pseudoJoins := joins select: [:each | each tablesForANSIJoin size < 2].
	pseudoJoins do: [:each | whereClause := each AND: whereClause].
	realJoins :=  joins select: [:each| each tablesForANSIJoin size >= 2].
	joins := realJoins.