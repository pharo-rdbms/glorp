Class {
	#name : #ASOrderLineItem,
	#superclass : #Object,
	#instVars : [
		'posNo',
		'quantity',
		'item',
		'price',
		'order'
	],
	#category : 'Glorp-Tests-Models'
}

{ #category : #accessing }
ASOrderLineItem >> item [

	^item
]

{ #category : #accessing }
ASOrderLineItem >> item: anObject [

	item := anObject
]

{ #category : #accessing }
ASOrderLineItem >> order [

	^order
]

{ #category : #accessing }
ASOrderLineItem >> order: anObject [

	order := anObject
]

{ #category : #accessing }
ASOrderLineItem >> posNo [

	^posNo
]

{ #category : #accessing }
ASOrderLineItem >> posNo: anObject [

	posNo := anObject
]

{ #category : #accessing }
ASOrderLineItem >> price [

	^price
]

{ #category : #accessing }
ASOrderLineItem >> price: anObject [

	price := anObject
]

{ #category : #accessing }
ASOrderLineItem >> quantity [

	^quantity
]

{ #category : #accessing }
ASOrderLineItem >> quantity: anObject [

	quantity := anObject
]
