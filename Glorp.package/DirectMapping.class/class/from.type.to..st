instance creation
from: attributeName type: aClass to: field

	^(self new)
		attributeName: attributeName;
		field: field;
		type: aClass.