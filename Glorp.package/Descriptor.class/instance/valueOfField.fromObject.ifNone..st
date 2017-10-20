mapping
valueOfField: aField fromObject: anObject ifNone: aBlock
	| directMapping notFound |
	directMapping := self directMappingForField: aField.
	directMapping isNil
		ifFalse: [^directMapping valueOfField: aField fromObject: anObject].
	notFound := Object new.
	(self relationshipMappingsForField: aField)
		do:
			[:each | 
			| candidate |
			(each hasValueThatCanProvideField: aField from: anObject)
				ifTrue: [
					candidate := each valueOfField: aField fromObject: anObject ifNone: [notFound].
					candidate == notFound ifFalse: [^candidate]]].
	^aBlock value