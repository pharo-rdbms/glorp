mapping
valueOfField: aField fromObject: anObject ifNone: aBlock
	| targetField target |
	targetField := self transformationExpression targetForSource: aField.
	targetField isNil ifTrue: [^aBlock value].
	target := self getValueFrom: anObject.
	^self referenceDescriptor valueOfField: targetField fromObject: target.