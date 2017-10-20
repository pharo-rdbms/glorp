accessing
addQuery: aQuery
	queries isEmpty ifTrue: [primaryQuery := aQuery].
	queries add: aQuery