examples
exampleInStorePurchase5
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 105.
	purchase title: 'ET'.
	purchase price: 5.00.
	purchase inStore: true.
	^purchase.