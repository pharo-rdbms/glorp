expression protocol
get: aSymbol withArguments: anArray 
	| arguments |
	arguments := anArray collect: [:each | each glorpIsBlock 
		ifTrue: [(Dialect argumentCountFor: each) = 1
			ifTrue: [each value: self]
			ifFalse: [each value]]
		ifFalse: [each]].
	^MessageArchiver receiver: self
		selector: aSymbol
		arguments: arguments