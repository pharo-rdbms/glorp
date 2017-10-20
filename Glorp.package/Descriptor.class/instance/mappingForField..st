accessing
mappingForField: aField

	^(self mappingsForFields at: aField ifAbsent: [^nil]) first