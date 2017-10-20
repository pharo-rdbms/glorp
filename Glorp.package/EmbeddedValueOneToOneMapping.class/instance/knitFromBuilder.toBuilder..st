mapping
knitFromBuilder: sourceBuilder toBuilder: targetBuilder 
	sourceBuilder requiresPopulating ifFalse: [^self].
	super knitFromBuilder: sourceBuilder toBuilder: targetBuilder