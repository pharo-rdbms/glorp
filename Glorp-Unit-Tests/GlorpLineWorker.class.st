Class {
	#name : #GlorpLineWorker,
	#superclass : #GlorpEmployee,
	#instVars : [
		'productionLine'
	],
	#category : #'Glorp-Unit-Tests-Models'
}

{ #category : #comparing }
GlorpLineWorker >> = aLineWorker [
	^super = aLineWorker and: [productionLine = aLineWorker productionLine].
]

{ #category : #accessing }
GlorpLineWorker >> productionLine [
	^productionLine
]

{ #category : #accessing }
GlorpLineWorker >> productionLine: anObject [
	productionLine := anObject
]
