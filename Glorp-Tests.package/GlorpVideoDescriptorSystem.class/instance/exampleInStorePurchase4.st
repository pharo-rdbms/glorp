examples
exampleInStorePurchase4
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 104.
	purchase title: 'Dogma'.
	purchase price: 4.00.
	purchase inStore: true.
	^purchase.