Extension { #name : #DateAndTime }

{ #category : #'*Glorp' }
DateAndTime >> asMilliseconds [
	"Answer the number of milliseconds since midnight"

	^ self asSeconds * 1000 + self milliseconds

]

{ #category : #'*Glorp' }
DateAndTime >> milliseconds [
	"Added for GLORP compatibility"

	^(nanos / 1000000.0) truncated
]
