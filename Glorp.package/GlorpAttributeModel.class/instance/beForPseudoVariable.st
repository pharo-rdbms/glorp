accessing
beForPseudoVariable
	"Make this be a pseudo-variable - one which is neither read nor written, and doesn't have a corresponding instance variable, but is only used for queries."
	canRead := false.
	canWrite := false