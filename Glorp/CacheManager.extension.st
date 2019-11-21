Extension { #name : #CacheManager }

{ #category : #'*Glorp' }
CacheManager classSide >> forSession: aSession [ 
	^self new session: aSession.
]

{ #category : #'*Glorp' }
CacheManager classSide >> new [

	^super new initialize.
]
