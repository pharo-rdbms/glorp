examples
exampleInStorePurchase1
	| purchase |
	purchase := GlorpVideoPurchase new.
	purchase id: 101.
	purchase title: 'An American in Paris'.
	purchase price: 1.00.
	purchase inStore: true.
	^purchase.