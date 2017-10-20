examples
exampleInStoreRental1
	| rental |
	rental := GlorpVideoRental new.
	rental id: 1001.
	rental title: 'Amelie'.
	rental price: 21.00.
	rental dueDate: Date today.
	^rental.