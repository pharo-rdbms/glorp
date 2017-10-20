optimization parameters
shouldUpdateOnlyChangedFieldsFor: aRow
	"Return true if we should write only changed fields out in an update statement, or if we should write all of them. The tradeoff is that writing only the changed ones will produce less SQL, but make more variations of the statement, and require us to keep more prepared statements around if we're using binding. By default, use this option only if we're not using binding by default"
	^aRow useBinding not