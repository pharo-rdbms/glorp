"
This is a select command that uses a number of sub-commands to print multiple queries, and combine them into one for execution. Used in conjunction with compound queries, e.g. using UNION ALL. The query knows what the combination operation is.

Instance Variables:
	commands	<(Collection of: DatabaseCommand)>	The commands we are to print.
"
Class {
	#name : #CompoundSelectCommand,
	#superclass : #QuerySelectCommand,
	#instVars : [
		'commands'
	],
	#category : #'Glorp-Core'
}

{ #category : #accessing }
CompoundSelectCommand >> arrayBoundFields [
	" *** This method was defined by Glorp.DatabaseCommand as a subclass responsibility.
	Replace its body with a proper implementation. *** "

	self error: 'Subclass responsibility stub not reimplemented'
]

{ #category : #accessing }
CompoundSelectCommand >> bindingTypes [

	^ self commands
		  inject: #(  )
		  into: [ :sum :each | sum , each bindingTypes ]
]

{ #category : #accessing }
CompoundSelectCommand >> bindings [

	^ commands inject: #(  ) into: [ :sum :each | sum , each bindings ]
]

{ #category : #accessing }
CompoundSelectCommand >> commands [

	commands isNil ifTrue: [
		commands := query queries collect: [ :each |
			            each sqlWith: parameters ] ].
	^ commands
]

{ #category : #testing }
CompoundSelectCommand >> hasGrouping [
	^self query hasGrouping
]

{ #category : #testing }
CompoundSelectCommand >> hasLimit [

	^self query hasLimit
]

{ #category : #testing }
CompoundSelectCommand >> hasOffset [

	^self query hasOffset
]

{ #category : #testing }
CompoundSelectCommand >> hasOrdering [

	^self query hasOrdering
]

{ #category : #accessing }
CompoundSelectCommand >> parameters: aDictionary [

	parameters := aDictionary.
	commands := nil
]

{ #category : #printing }
CompoundSelectCommand >> printSQL [
	"Access doesn't like parenthesies around the first in a group of compound commands."

	| skipFirst |
	self requiresWrapperQuery
		ifTrue: [
			self nextPutAll: 'SELECT '.
			self requiresDistinct
				ifTrue:  [ self nextPutAll: 'DISTINCT '].
			self nextPutAll: '* FROM '.
			self platform supportsAliasInCompoundQuery ifTrue: [self nextPut: $( ]].
	skipFirst := self platform parenthesizeAllButFirstCommandInCompoundQuery.
	GlorpHelper
		do:
			[:each |
			(self platform parenthesizeCommandsInCompoundQuery and: [skipFirst not])
				ifTrue: [self nextPut: $(].
			self nextPutAll: each sqlString.
			(self platform parenthesizeCommandsInCompoundQuery and: [skipFirst not])
				ifTrue: [self nextPut: $)].
			skipFirst := false]
		for: self commands
		separatedBy: [query printOperationOn: self].
	(self requiresWrapperQuery and: [self platform supportsAliasInCompoundQuery])
		ifTrue:
			[self nextPut: $).
			query printCompoundSelectAliasesOn: self].

	query printOrderingOn: self.
	query printGroupingOn: self.
	query printPostLimitOn: self.
	query printOffsetOn: self
]

{ #category : #testing }
CompoundSelectCommand >> requiresDistinct [
	^self query requiresDistinct.
]

{ #category : #testing }
CompoundSelectCommand >> requiresWrapperQuery [
    ^ self requiresDistinct
		or: [ self hasOrdering
			or: [ self hasGrouping
				or: [ self hasLimit
					or: [ self hasOffset ] ] ] ] 
]
