private/mapping
reverseLookup: anObject

      (self isRowMapKey: anObject) ifTrue: [
            ^anObject reverseAdjustIn: self].
      ^ self reversedCorrespondenceMap at: anObject