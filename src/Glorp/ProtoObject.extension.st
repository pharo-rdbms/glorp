Extension { #name : 'ProtoObject' }

{ #category : '*Glorp-Core' }
ProtoObject >> _isProxy [
	^true.
]

{ #category : '*Glorp' }
ProtoObject >> asGlorpExpression [
	^GlorpHelper glorpConstantExpressionClass for: self.
]

{ #category : '*Glorp' }
ProtoObject >> asGlorpExpressionOn: anExpression [

	^self asGlorpExpression.
]

{ #category : '*Glorp' }
ProtoObject >> asGlorpExpressionOn: anExpression basedOn: aMessageArchiver withUltimateBase: aBaseExpression [

	^self asGlorpExpression.
]

{ #category : '*Glorp' }
ProtoObject >> isGlorpExpression [
	^false.
]

{ #category : '*Glorp' }
ProtoObject >> isGlorpProxy [
	^false.
]

{ #category : '*Glorp' }
ProtoObject >> isKindOf: aClass [
	^self class includesBehavior: aClass.
]
