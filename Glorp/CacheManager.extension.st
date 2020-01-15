Extension { #name : #CacheManager }

{ #category : #'*Glorp' }
CacheManager class >> forSession: aSession [ 
	^self new session: aSession.
]

{ #category : #'*Glorp' }
CacheManager class >> new [

	^super new initialize.
]
