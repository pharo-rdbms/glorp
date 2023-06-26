Class {
	#name : #GlorpObjectComparisonSubselectTest,
	#superclass : #GlorpObjectComparisonJoinsTest,
	#category : #'Glorp-Integration-Tests-Database'
}

{ #category : #running }
GlorpObjectComparisonSubselectTest >> setUp [

	super setUp.
	session system useJoinsForAnySatisfy: false
]
