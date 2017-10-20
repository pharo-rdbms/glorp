mapping
knitFromBuilder: sourceBuilder toBuilder: targetBuilder 
	self canRead ifFalse: [^self].
	self attribute knit: sourceBuilder instance to: targetBuilder instance