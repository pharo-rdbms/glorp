instance creation
from: from1Field to: to1Field
from: from2Field to: to2Field
from: from3Field to: to3Field

	^self new
		addSource: from1Field target: to1Field;
		addSource: from2Field target: to2Field;
		addSource: from3Field target: to3Field