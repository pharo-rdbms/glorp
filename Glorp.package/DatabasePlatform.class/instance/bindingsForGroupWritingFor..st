binding
bindingsForGroupWritingFor: aCommand
	"Return the bindings array for a group write. This can be in different formats, depending on the database and perhaps the mechanism in place."
	self subclassResponsibility.