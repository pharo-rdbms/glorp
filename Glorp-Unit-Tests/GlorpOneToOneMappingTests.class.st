Class {
	#name : #GlorpOneToOneMappingTests,
	#superclass : #GlorpSessionBasedTest,
	#instVars : [
		'sessionsPool',
		'lastPoolSessionIndex'
	],
	#category : #'Glorp-Unit-Tests-Tests'
}

{ #category : #accessing }
GlorpOneToOneMappingTests >> createNewFreshSession [

	| freshSession |

	freshSession := GlorpSession new.
	freshSession accessor: ( DatabaseAccessor forLogin: self defaultLogin ).
	freshSession system: system copy.
	freshSession loginIfError: [ :error | self halt: error description ].
	^ freshSession
]

{ #category : #accessing }
GlorpOneToOneMappingTests >> defaultLogin [

	^ GlorpDatabaseLoginResource defaultLogin
]

{ #category : #'test support' }
GlorpOneToOneMappingTests >> inFreshTransactionDo: aBlock [

	self
		withFreshSessionDo: [ :sess | 
			sess transact: aBlock
			]
]

{ #category : #'test support' }
GlorpOneToOneMappingTests >> inTransactionDo: aBlock [

	session transact: aBlock.
	session reset
]

{ #category : #initialization }
GlorpOneToOneMappingTests >> setUp [

	super setUp.
	system := GlorpTradeDescriptorSystem forPlatform: session platform.
	session system: system.
	session recreateTablesIfError: [ :error | Error signal: error description ].

	sessionsPool := OrderedCollection new
		add: self createNewFreshSession;
		add: self createNewFreshSession;
		add: self createNewFreshSession;
		yourself.

	lastPoolSessionIndex := -1
]

{ #category : #initialization }
GlorpOneToOneMappingTests >> tearDown [

	super tearDown.

	sessionsPool
		do: #reset;
		do: #logout.

	sessionsPool := nil
]

{ #category : #'test - single session' }
GlorpOneToOneMappingTests >> testRegisterAccountPreviouslyUsingOneSession [

	| account trade found |

	self assert: ( session read: GlorpAccount ) isEmpty.
	account := GlorpAccount knownAs: 'example account'.
	self inTransactionDo: [ session register: account ].
	self assert: ( session read: GlorpAccount ) size equals: 1.

	self assert: ( session read: GlorpTrade ) isEmpty.
	trade := GlorpTrade within: account.

	self inTransactionDo: [ session register: trade ].

	found := session read: GlorpTrade.
	self assert: found size equals: 1.
	found := found first.
	self assert: found id equals: trade id.
	self assert: found account id equals: account id
]

{ #category : #'test - session pool' }
GlorpOneToOneMappingTests >> testRegisterAccountPreviouslyUsingSessionPool [

	| account trade found |

	self withFreshSessionDo: [ :sess | self assert: ( sess read: GlorpAccount ) isEmpty ].
	account := GlorpAccount knownAs: 'example account'.
	self inFreshTransactionDo: [ :sess | sess register: account ].
	self withFreshSessionDo: [ :sess | self assert: ( sess read: GlorpAccount ) size equals: 1 ].

	self withFreshSessionDo: [ :sess | self assert: ( sess read: GlorpTrade ) isEmpty ].
	trade := GlorpTrade within: account.

	self inFreshTransactionDo: [ :sess | sess register: trade ].

	self withFreshSessionDo: [ :sess | found := sess read: GlorpTrade ].
	self assert: found size equals: 1.
	found := found first.
	self assert: found id equals: trade id.
	self assert: found account id equals: account id
]

{ #category : #'test - single session' }
GlorpOneToOneMappingTests >> testRegisterAccountTransitivelyUsingOneSession [

	| account trade found |

	self assert: ( session read: GlorpAccount ) isEmpty.
	self assert: ( session read: GlorpTrade ) isEmpty.

	account := GlorpAccount knownAs: 'example account'.
	trade := GlorpTrade within: account.

	self inTransactionDo: [ session register: trade ].

	found := session read: GlorpAccount.
	self assert: found size equals: 1.
	self assert: found first id equals: account id.

	found := session read: GlorpTrade.
	self assert: found size equals: 1.
	found := found first.
	self assert: found id equals: trade id.
	self assert: found account id equals: account id
]

{ #category : #'test - session pool' }
GlorpOneToOneMappingTests >> testRegisterAccountTransitivelyUsingSessionsPool [

	| account trade found |

	self withFreshSessionDo: [ :sess | self assert: ( sess read: GlorpAccount ) isEmpty ].
	self withFreshSessionDo: [ :sess | self assert: ( sess read: GlorpTrade ) isEmpty ].

	account := GlorpAccount knownAs: 'example account'.
	trade := GlorpTrade within: account.

	self inFreshTransactionDo: [ :sess | sess register: trade ].

	self withFreshSessionDo: [ :sess | found := sess read: GlorpAccount ].
	self assert: found size equals: 1.
	self assert: found first id equals: account id.

	self withFreshSessionDo: [ :sess | found := sess read: GlorpTrade ].
	self assert: found size equals: 1.
	found := found first.
	self assert: found id equals: trade id.
	self assert: found account id equals: account id
]

{ #category : #'test support' }
GlorpOneToOneMappingTests >> withFreshSessionDo: aBlock [

	| currentIndex freshSession |

	currentIndex := ( lastPoolSessionIndex + 1 rem: sessionsPool size ) + 1.
	freshSession := sessionsPool at: currentIndex.
	[ aBlock value: freshSession ]
		ensure: [ freshSession reset.
			lastPoolSessionIndex := currentIndex - 1
			]
]
