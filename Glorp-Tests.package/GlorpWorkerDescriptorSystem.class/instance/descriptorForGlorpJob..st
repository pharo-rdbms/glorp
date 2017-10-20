descriptors
descriptorForGlorpJob: aDescriptor 
	"Note that the job table contains a FINISHED field, but the GlorpJob object doesn't. This field is determined only by membership in the finished or pending collections. In this particular case it's not very useful from a domain perspective, but it's interesting to be able to map. Similarly, whether a job is priority or not is not in the domain object, and is stored in the link table defining the relationship"

	| table |
	table := self tableNamed: 'GLORP_JOB'.
	aDescriptor table: table.
	aDescriptor addMapping: (DirectMapping from: #id
				to: (table fieldNamed: 'ID')).
	aDescriptor addMapping: (DirectMapping from: #description
				to: (table fieldNamed: 'DESCRIPTION')).