internal
buildReplacementTableSelect
	"We have an imaginary table which is defined by selecting from our attributes instead of from the table. Build the query for that."

	| sourceMappings targetMappings mainQuery subQuery |
	mainQuery := nil.
	sourceMappings := imaginaryTableReplacements
		collect: [:each | self mappingForAttributeNamed: each first].
	targetMappings := imaginaryTableReplacements
		collect: [:each | self mappingForAttributeNamed: each last].
	sourceMappings
		with: targetMappings
		do:
			[:eachSourceMapping :eachTargetMapping | 
			subQuery := self
				buildReplacementTableSelectFrom: eachSourceMapping
				to: eachTargetMapping.
			mainQuery := mainQuery isNil
				ifTrue: [subQuery]
				ifFalse: [mainQuery unionAll: subQuery]].
	mainQuery session: self session.
	self primaryTable replacementSubSelect: mainQuery