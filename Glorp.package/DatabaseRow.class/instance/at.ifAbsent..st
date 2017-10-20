accessing
at: aField ifAbsent: absentBlock

	^(self wrapperAt: aField ifAbsent: [^absentBlock value]) contents.