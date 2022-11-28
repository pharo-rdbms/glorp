"
SQLiteProxy is different from a normal proxy in that its >>glorpTriggerProxyAction: method passes back the result of the block, which the >>getValue method reassigns to the originally retrieved #value inst var. The idea is to have a proxy that represents a DatabaseField, when there is no such entity in any SQLite schema table, so it must be constructed from a variety of special SQLite3 function calls (called pragmas).

"
Class {
	#name : #SQLite3Proxy,
	#superclass : #Proxy,
	#category : 'Glorp-Queries'
}

{ #category : #accessing }
SQLite3Proxy >> class [
	^SQLite3Proxy
]

{ #category : #api }
SQLite3Proxy >> getValue [
	"This method further modifies the retrieved value using the action block."

	self isInstantiated ifTrue: [^value].
	parameters isNil ifTrue: [parameters := Dictionary new: 0].
	
	[value := query isNil
				ifTrue: [nil]
				ifFalse: [query executeWithParameters: parameters in: session]]
			ensure: [isInstantiated := true].
	value := self glorpTriggerProxyAction: value.
	^value
]

{ #category : #'proxy actions' }
SQLite3Proxy >> glorpTriggerProxyAction: target [
	"Evaluate our action with the owner and the newly retrieved target.
	Return the result of this evaluation, or self if there is no action.
	Since the return value has ambiguous semantics, this needs work."

	| owner block |
	action isNil ifTrue: [^self].
	owner := action key.
	block := action value.
	^block value: owner value: target
]
