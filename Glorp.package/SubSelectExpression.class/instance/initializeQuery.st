accessing
initializeQuery
	query := Query
		read: localBase descriptor describedClass
		where: rightChild.
	query tablePrefix: ('s', localBase ultimateBaseExpression availableSubSelectNumber printString, 't').
"	query baseExpression: localBase."
	query session: localBase descriptor session.
	localBase descriptor tables do: [:eachTable |
		eachTable primaryKeyFields do: [:each | query retrieve: [:base | base getField: each]]].