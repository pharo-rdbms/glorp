Extension { #name : 'Proxy' }

{ #category : '*Glorp' }
Proxy class >> read: aClass where: aBlock [
	^self new query: (Query read: aClass where: aBlock)
]

{ #category : '*Glorp' }
Proxy class >> read: aClass where: aBlock in: aSession [
	^self new
		query: (Query read: aClass where: aBlock);
		session: aSession
]

{ #category : '*Glorp' }
Proxy class >> readOneOf: aClass where: aBlock [
	^self new query: (Query readOneOf: aClass where: aBlock)
]

{ #category : '*Glorp' }
Proxy class >> readOneOf: aClass where: aBlock in: aSession [
	^self new
		query: (Query readOneOf: aClass where: aBlock);
		session: aSession.
]

{ #category : '*Glorp' }
Proxy class >> returningManyOf: aClass where: aBlock [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: aBlock
]

{ #category : '*Glorp' }
Proxy class >> returningManyOf: aClass where: aBlock in: aSession [
	"readManyOf: and returningManyOf: are synonyms of read:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #read:where: instead'.
	^self read: aClass where: aBlock in: aSession
]

{ #category : '*Glorp' }
Proxy class >> returningOneOf: aClass where: aBlock [
	"returningOneOf: is a synonyms of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: aBlock
]

{ #category : '*Glorp' }
Proxy class >> returningOneOf: aClass where: aBlock in: aSession [
	"returningOneOf: is a synonyms of readOneOf:. This now seems more natural to me, to be consistent with session API."

	self deprecated: 'Use #readOneOf:where: instead'.
	^self readOneOf: aClass where: aBlock in: aSession
]
