validation
validate

	| targetClassModel |
	super validate.
	(self collectionType = GlorpCursoredStream and: [self shouldUseFilteredRead]) ifTrue: [self error: 'Filtered mappings can cause duplicates and so cannot return cursors'].

	(shouldWriteTheOrderField and: [orderBy isNil]) ifTrue: [self error: 'Mapping tries to write the collection order to a field, but has no order by field specified'].
	(shouldWriteTheOrderField & usesLinkTable)
		ifTrue: [ | targetTable |
			targetTable := (self linkTableJoin allTargetFields collect: [:each | each table]) first.
			targetTable primaryKeyFields isEmpty ifTrue: [self error: 'A mapping with a link table and which writes the order field must define primary key fields and must not include the order field as a primary key']].
	
	orderBy isNil ifTrue: [^self].
	targetClassModel := self system classModelFor: attribute type.

	"Note that this will only validate when the orderBy is a symbol - not a block, expression, or field"
	orderBy do: [:attributeName |
		attributeName isSymbol ifTrue: [
			(targetClassModel hasAttributeNamed: attributeName) ifFalse: [
				self error: attribute printString, ' is attempting to order by #', attributeName, ' which is not a mapped attribute of ', targetClassModel describedClass name]]].