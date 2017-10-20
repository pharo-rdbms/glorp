internal
describedConcreteClassFor: row withBuilder: builder
	"Lookup the class that is represented by the row when there is a possibility
		of this row representing any class within a hierarchy. "
	^self typeResolver describedConcreteClassFor: row withBuilder: builder descriptor: self