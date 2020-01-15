Extension { #name : #Cache }

{ #category : #'*Glorp' }
Cache class >> new [

	^super new initialize.
]

{ #category : #'*Glorp' }
Cache class >> newFor: aClass in: aCacheManager [ 
	| newCache descriptor |
	descriptor := aCacheManager session isNil ifFalse: [aCacheManager system descriptorFor: aClass].
	newCache := Cache new.
	newCache mainCache: aCacheManager.
	descriptor isNil 
		ifTrue: [newCache cachePolicy: CachePolicy default]
		ifFalse: [newCache cachePolicy: descriptor cachePolicy].
	^newCache.
]
