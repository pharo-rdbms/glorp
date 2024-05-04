"
This is a special subclass of ElementBuilder used when we execute a query that reads multiple different things, but in any row, we expect only one of them to have a value. This is useful if we're doing inheritance queries where each concrete subclass is in a separate table. We can join the queries together, but we expect each row to contain only one particular subclass instance.
"
Class {
	#name : 'SelectingElementBuilder',
	#superclass : 'ElementBuilder',
	#category : 'Glorp-Queries',
	#package : 'Glorp',
	#tag : 'Queries'
}

{ #category : 'building objects' }
SelectingElementBuilder >> buildObjectFrom: anArray [
	^self
]

{ #category : 'selecting fields' }
SelectingElementBuilder >> fieldsForSelectStatement [
	^#()
]

{ #category : 'selecting fields' }
SelectingElementBuilder >> fieldsFromMyPerspective [
	^#()
]

{ #category : 'building objects' }
SelectingElementBuilder >> findInstanceForRow: aRow proxyType: proxyType [
	^self
]

{ #category : 'building objects' }
SelectingElementBuilder >> returnValueIn: aCursoredStream [
	| builder |
	builder := aCursoredStream privateGetBuilders
		detect:
			[:each | 
			each instance notNil
				and: [each expression ~~ aCursoredStream command query baseExpression]]
		ifNone:
			[self error: 'Internal error in computing horizontal inheritance query.'].
	^builder instance
]
