preparing
setupTracing
	| |
	builders isNil ifFalse: [^self].	"Already been done"
	super setupTracing.
	builders := tracing allTracings asArray
		inject: #()
		into:
			[:sum :each | sum , (ElementBuilder for: each in: self) withAllSubBuilders].
	self addOrderingForToManyJoins