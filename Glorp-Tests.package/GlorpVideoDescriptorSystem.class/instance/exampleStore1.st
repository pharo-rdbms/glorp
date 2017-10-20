examples
exampleStore1
	"self new exampleStore1"
	| example |
	example := GlorpVideoStore new.
	example name: 'Als Video'.
	example id: 1.
	example customers: (Array with: self exampleCustomer1 with: self exampleCustomer2 with: self exampleCustomer3 with: self exampleCustomer4), (Array with: self exampleCustomer5 with: self exampleCustomer6 with: self exampleCustomer7).
	example computeCollections.
	^example.