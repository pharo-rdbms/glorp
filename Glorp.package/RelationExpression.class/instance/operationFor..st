private/initializing
operationFor: aSymbol
	"Simple translation of operators"

	aSymbol == #AND: ifTrue: [^#AND].
	aSymbol == #& ifTrue: [^#AND].
	aSymbol == #OR: ifTrue: [^#OR].
	aSymbol == #| ifTrue: [^#OR].
	aSymbol == #~= ifTrue: [^#<>].
	 aSymbol == #like: ifTrue: [^#LIKE].
	 aSymbol == #ilike: ifTrue: [^#ILIKE].		"Case-insensitive variant of LIKE. Only supported on PostgreSQL at the moment"
	 aSymbol == #in: ifTrue: [^#IN].
	 aSymbol == #notIn: ifTrue: [^#'NOT IN'].

	^aSymbol.