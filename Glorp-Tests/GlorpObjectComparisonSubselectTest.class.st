Class {
	#name : #GlorpObjectComparisonSubselectTest,
	#superclass : #GlorpObjectComparisonJoinsTest,
	#category : 'Glorp-Tests-Database'
}

{ #category : #support }
GlorpObjectComparisonSubselectTest >> setUp [
	super setUp.
	session system useJoinsForAnySatisfy: false.
]
