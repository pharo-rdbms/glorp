"
This represents a simple one to one relationship, e.g. from Person to Address. Assuming each person has only one address. Note that this has no methods, and only really exists for backward compatibility purposes, since a to-one relationship is the default for RelationshipMapping.
"
Class {
	#name : #OneToOneMapping,
	#superclass : #RelationshipMapping,
	#category : 'Glorp-Mappings'
}
