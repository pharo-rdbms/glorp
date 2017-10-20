instance creation
from: from1Field to: to1Field
from: from2Field to: to2Field

	^self new
		addSource: from1Field target: to1Field;
		addSource: from2Field target: to2Field