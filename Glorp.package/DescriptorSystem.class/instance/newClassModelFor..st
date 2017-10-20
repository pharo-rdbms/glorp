private
newClassModelFor: aClass

	| newClassModel |
	newClassModel := GlorpClassModel new.
	newClassModel system: self.
	newClassModel describedClass: aClass.
	self initializeClassModel: newClassModel.
	^newClassModel