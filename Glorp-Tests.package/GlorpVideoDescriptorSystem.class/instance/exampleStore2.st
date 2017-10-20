examples
exampleStore2
	"self new exampleStore2"
	| example |
	example := GlorpVideoStore new.
	example name: 'Bonzai Video'.
	example id: 2.
	example customers: (Array with: self exampleCustomer8).
	example computeCollections.
	^example.