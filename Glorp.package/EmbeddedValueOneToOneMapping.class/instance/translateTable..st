mapping
translateTable: aTable
	"If we have a field translation, return the translated (i.e. real) table to use. This ideally allows us to use either the real table in which something is embedded, or the imaginary table"

	fieldTranslation isNil ifTrue: [^aTable].
	1 to: fieldTranslation allTargetFields size
		do:
			[:i | 
			(fieldTranslation allTargetFields at: i) table == aTable
				ifTrue: [^(fieldTranslation allSourceFields at: i) table]].
	^aTable.