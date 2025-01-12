"
This implements the Glorp database proxy behaviour, for proxies that get their result by evaluating a query using a particular set of parameters, in the context of a particular Glorp query.

Instance Variables:
	parameters	<Dictionary | SequenceableCollection>	Our parameters, keyed either by name or by index.
	query	<Query>	The query we will evaluate. Note that for a mapping, all proxies will share the same query instance.
	session	<GlorpSession>	The session in which this proxy exists, and against which the query will be executed to find our value.


"
Class {
	#name : #Proxy,
	#superclass : #AbstractProxy,
	#instVars : [
		'session',
		'query',
		'parameters',
		'action'
	],
	#category : #'Glorp-Queries'
}

{ #category : #reading }
Proxy class >> read: aClass where: aBlock [
	^self new query: (Query read: aClass where: aBlock)
]

{ #category : #'*Glorp' }
Proxy class >> read: aClass where: aBlock in: aSession [
	^self new
		query: (Query read: aClass where: aBlock);
		session: aSession
]

{ #category : #'*Glorp' }
Proxy class >> readOneOf: aClass where: aBlock [
	^self new query: (Query readOneOf: aClass where: aBlock)
]

{ #category : #'*Glorp' }
Proxy class >> readOneOf: aClass where: aBlock in: aSession [
	^self new
		query: (Query readOneOf: aClass where: aBlock);
		session: aSession.
]

{ #category : #'*Glorp' }
Proxy class >> returningManyOf: aClass where: aBlock [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: aBlock
]

{ #category : #'*Glorp' }
Proxy class >> returningManyOf: aClass where: aBlock in: aSession [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: aBlock in: aSession
]

{ #category : #'*Glorp' }
Proxy class >> returningOneOf: aClass where: aBlock [
	"returningOneOf: is a synonyms of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: aBlock
]

{ #category : #deprecated }
Proxy class >> returningOneOf: aClass where: aBlock in: aSession [
	"returningOneOf: is a synonyms of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: aBlock in: aSession
]

{ #category : #accessing }
Proxy >> = anObject [
	"In VA we inherit this as identity. Need to override"
	^self isGlorpProxy & anObject isGlorpProxy
		ifTrue: [ self getValue = anObject getValue ]
		ifFalse: [ super = anObject ]
]

{ #category : #accessing }
Proxy >> class [

	^Proxy
	"self isInstantiated ifTrue: [^value class].
	query isNil ifTrue: [^Proxy].
	query resultClass isNil ifTrue: [^Proxy].
	^query resultClass."
]

{ #category : #api }
Proxy >> getValue [
	self isInstantiated ifTrue: [^value].
	parameters isNil ifTrue: [parameters := Dictionary new: 0].
	[value := query isNil
		ifTrue: [nil]
		ifFalse: [query executeWithParameters: parameters in: session]]
		ensure: [isInstantiated := true].
	self glorpTriggerProxyAction: value.
	^value.
]

{ #category : #'proxy actions' }
Proxy >> glorpArmProxy [
	value ifNil: [ isInstantiated := false ].
	^self
]

{ #category : #'proxy actions' }
Proxy >> glorpOwner [
	"Return the object for which this proxy was created. Note that this is not kept track of unless we have a proxy action."
	action isNil ifTrue: [^nil].
	^action key.
]

{ #category : #'proxy actions' }
Proxy >> glorpOwner: anObject [
	"If we don't have an action, the owner is unnecessary. Ignore it. If we do have one, put it in as the key of an association with the action block following it."
	action isNil ifTrue: [^self].
	action key: anObject.
	isInstantiated := false.
]

{ #category : #'proxy actions' }
Proxy >> glorpProxyAction [
	"Return the block we expect to evaluate when the proxy is fired."
	action isNil ifTrue: [^nil].
	^action value.
]

{ #category : #'proxy actions' }
Proxy >> glorpProxyAction: aTwoArgumentBlock [
	"Set the action we'll take when the proxy fires. This is a two argument block that takes the owning object and the value of the proxy as arguments."
	aTwoArgumentBlock isNil ifTrue: [^action := nil].
	action := nil -> aTwoArgumentBlock
]

{ #category : #'proxy actions' }
Proxy >> glorpTriggerProxyAction: target [
	"Evaluate our action with the owner and the newly retrieved target."
	| owner block |
	action isNil ifTrue: [^self].
	owner := action key.
	block := action value.
	block value: owner value: target
]

{ #category : #accessing }
Proxy >> isKindOf: aClass [
	self isInstantiated ifTrue: [^value isKindOf: aClass].
	query isNil ifTrue: [^false].
	query resultClass isNil ifTrue: [^false].
	query resultClass isBehavior ifFalse: [^false].
	^query resultClass includesBehavior: aClass
]

{ #category : #accessing }
Proxy >> parameters [
	^parameters
]

{ #category : #accessing }
Proxy >> parameters: aDictionary [
	parameters := aDictionary.
	isInstantiated := false.
]

{ #category : #printing }
Proxy >> printOn: aStream [ 
	aStream nextPut: ${.
	isInstantiated 
		ifTrue: [self getValue printOn: aStream]
		ifFalse: 
			[aStream nextPutAll: 'uninstantiated '.
			query isNil
				ifTrue: [aStream nextPutAll: '???']
				ifFalse: [
					query readsOneObject ifFalse: [aStream nextPutAll: 'collection of '].
					aStream nextPutAll: query resultClass name]].
	aStream nextPut: $}
]

{ #category : #accessing }
Proxy >> query [
	^query
]

{ #category : #accessing }
Proxy >> query: aQuery [ 
	query := aQuery
]

{ #category : #accessing }
Proxy >> session [
	^session
]

{ #category : #accessing }
Proxy >> session: aSession [ 
	session := aSession
]

{ #category : #accessing }
Proxy >> species [

	self isInstantiated ifTrue: [^value species].
	query isNil ifTrue: [^Proxy].
	query resultClass isNil ifTrue: [^Proxy].
	^query resultClass species

]
