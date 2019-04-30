Extension { #name : #IdentityDictionary }

{ #category : #'*Glorp' }
IdentityDictionary >> glorpAtIdentity: aKey ifAbsent: aBlock [
	^self at: aKey ifAbsent: aBlock.
]
