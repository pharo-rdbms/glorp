Extension { #name : #SortedCollection }

{ #category : #'*Glorp' }
SortedCollection >> writeStream [
	^AddingWriteStream on: self.
]
