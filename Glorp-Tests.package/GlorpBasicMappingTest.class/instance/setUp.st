support
setUp

	super setUp.
	mapping := DirectMapping new.
	mapping attributeName: #id.
	mapping attribute classModel describedClass: GlorpPerson.
	person := GlorpPerson example1.