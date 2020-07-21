Class {
	#name : #GlorpObjectComparisonSubselectTest,
	#superclass : #GlorpObjectComparisonJoinsTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #support }
GlorpObjectComparisonSubselectTest >> setUp [
	super setUp.
	session system useJoinsForAnySatisfy: false.
]
