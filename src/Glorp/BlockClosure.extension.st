Extension { #name : #BlockClosure }

{ #category : #'*Glorp-Core' }
BlockClosure >> asGlorpExpression [

	^self asGlorpExpressionOn: BaseExpression new.
]

{ #category : #'*Glorp-Core' }
BlockClosure >> asGlorpExpressionForDescriptor: aDescriptor [

	| base |
	base := BaseExpression new.
	base descriptor: aDescriptor.
	^self asGlorpExpressionOn: base.
]

{ #category : #'*Glorp-Core' }
BlockClosure >> asGlorpExpressionOn: anExpression [ 
	^(self value: MessageArchiver new) asGlorpExpressionOn: anExpression
]

{ #category : #'*Glorp-Core' }
BlockClosure >> asGlorpExpressionOn: anExpression in: aQuery [ 
	^(self value: (MessageArchiver new privateGlorpQuery: aQuery)) asGlorpExpressionOn: anExpression.
]

{ #category : #'*Glorp-Core' }
BlockClosure >> asGlorpExpressionOn: anExpression withUltimateBase: aBaseExpression [
	"Build the expression, knowing that some parts of it may refer to an outer context based on aBaseExpression. This is primarily useful for subselect blocks"
	| archiver tree |
	archiver := MessageArchiver new.
	tree := self value: archiver.
	^tree asGlorpExpressionOn: anExpression basedOn: archiver withUltimateBase: aBaseExpression.
]

{ #category : #'*Glorp-Core' }
BlockClosure >> glorpIsBlock [
	^true.
]
