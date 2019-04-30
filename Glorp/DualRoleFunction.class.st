"
This is a function that prints in different ways in a field list than it does in a where clause, typically because use of the where clause version isn't supported in field lists.
"
Class {
	#name : #DualRoleFunction,
	#superclass : #FunctionExpression,
	#instVars : [
		'arguments',
		'whereClauseVersion',
		'selectListVersion'
	],
	#category : 'Glorp-Expressions'
}

{ #category : #accessing }
DualRoleFunction >> arguments [
	^arguments.
]

{ #category : #accessing }
DualRoleFunction >> arguments: anArray [
	arguments := anArray.
	whereClauseVersion arguments: anArray.
	selectListVersion arguments: anArray.
]

{ #category : #converting }
DualRoleFunction >> asField [
	^self.
]

{ #category : #accessing }
DualRoleFunction >> base: anExpression [
	base := anExpression.
	"whereClauseVersion base: anExpression."
	selectListVersion base: anExpression.
]

{ #category : #accessing }
DualRoleFunction >> basicArguments: anArray [
	arguments := anArray.
]

{ #category : #accessing }
DualRoleFunction >> basicBase: anExpression [
	base := anExpression.
]

{ #category : #copying }
DualRoleFunction >> copy [
	| new |
	new := super copy.
	"We need to make sure we copy these before the base gets set. This is horribly ugly."
	new selectListVersion: selectListVersion copy.
	new whereClauseVersion: whereClauseVersion copy.
	^new.
]

{ #category : #copying }
DualRoleFunction >> createFor: argumentList withBase: anExpression symbol: aSymbol [
	| new newBase newArgument newFunction |
	new := super createFor: argumentList withBase: anExpression symbol: aSymbol.
	"For the where clause version, we've got a dualRoleFunction. We can't just rebuild the whole thing, so rebuild the children, and then re-assemble it recreating from the template."
	newBase := new whereClauseVersion base isNil ifTrue: [anExpression] ifFalse: [new whereClauseVersion base rebuildOn: anExpression].
	newArgument := new whereClauseVersion argument rebuildOn: anExpression.
	newFunction := self whereClauseVersion copy.
	newFunction symbol: aSymbol.
	newFunction base: newBase.
	newFunction argument: newArgument.
	new whereClauseVersion: newFunction.
	"Don't try to rebuild the selectListVersion at all, because at least for the motivating case we have, it's just a shell, not a full blown expression, and it will already have been copied."
	^new.
]

{ #category : #iterating }
DualRoleFunction >> do: aBlock skipping: aSet [
	"Iterate over the expression tree. Keep track of who has already been visited, so we don't get trapped in cycles or visit nodes twice."

	(aSet includes: self) ifTrue: [^self].
	super do: aBlock skipping: aSet.
	arguments do: [:each |
		each do: aBlock skipping: aSet].
]

{ #category : #accessing }
DualRoleFunction >> field [
	^whereClauseVersion field.
]

{ #category : #printing }
DualRoleFunction >> printSQLOn: aStream withParameters: aDictionary [
	whereClauseVersion printSQLOn: aStream withParameters: aDictionary.
]

{ #category : #printing }
DualRoleFunction >> printSelectSQLOn: aStream withParameters: aDictionary [
	selectListVersion printSelectSQLOn: aStream withParameters: aDictionary.
]

{ #category : #preparing }
DualRoleFunction >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	| rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	"Rebuilding just one of them will rebuild our whole structure, since it all comes from the same definition."
	rebuilt := whereClauseVersion rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
	rebuilt == whereClauseVersion ifTrue: [^self].

	rebuilt arguments: (self arguments collect: [:each | each rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression]).
	^rebuilt.
]

{ #category : #accessing }
DualRoleFunction >> selectListVersion [
	^selectListVersion.
]

{ #category : #accessing }
DualRoleFunction >> selectListVersion: aFunctionExpression [
	selectListVersion := aFunctionExpression.
]

{ #category : #accessing }
DualRoleFunction >> symbol: aSymbol [
	symbol := aSymbol.
	whereClauseVersion symbol: aSymbol.
	selectListVersion symbol: aSymbol.
]

{ #category : #accessing }
DualRoleFunction >> type: aSymbol [
	super type: aSymbol.
	whereClauseVersion type: aSymbol.
	selectListVersion type: aSymbol.
]

{ #category : #accessing }
DualRoleFunction >> whereClauseVersion [
	^whereClauseVersion.
]

{ #category : #accessing }
DualRoleFunction >> whereClauseVersion: aFunctionExpression [
	whereClauseVersion := aFunctionExpression.
]
