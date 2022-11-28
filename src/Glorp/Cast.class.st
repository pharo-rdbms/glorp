"
This is an attempt to allow a cast to be used on constants, as e.g.
   CAST value: '1-2-3' as: platform date
It doesn't work yet, since printing of constants doesn't like having functions in the way - it conflicts with type conversion, and looks like it'll take a bit of work to fix.
"
Class {
	#name : #Cast,
	#superclass : #PrefixFunction,
	#category : 'Glorp-Expressions'
}

{ #category : #'instance creation' }
Cast class >> value: anObject as: aDatabaseType [
	self error: 'this is work in progress, you probably shouldn''t use it yet'.
	(anObject isNil or: [anObject isGlorpExpression and: [anObject isConstantExpression and: [anObject value isNil]]])
		ifTrue: [^anObject].
	^self new base: anObject asGlorpExpression; arguments: (Array with: aDatabaseType asGlorpExpression)
]

{ #category : #'initialize-release' }
Cast >> initialize [
	super initialize.
	function := 'CAST'.
	separator := ' AS '.
]

{ #category : #preparing }
Cast >> rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression [
	^super rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression.
"	| rebuilt |
	self == anExpression ifTrue: [^aBaseExpression].
	rebuilt := (base rebuildOn: aBaseExpression startingFrom: anExpression withOuterScopeBase: ultimateBaseExpression).
	rebuilt := self class value: base as: arguments first.
	rebuilt alias: self alias.
	^rebuilt."
]

{ #category : #accessing }
Cast >> type [
	^arguments last value.
]
