"
This class contains tests for the GlorpInflector class.

The test data was initially taken from the unit test for the Ruby on Rails inflector at https://github.com/rails/rails/blob/f33d52c95217212cbacc8d5e44b5a8e3cdc6f5b3/activesupport/test/inflector_test_cases.rb. but there have been some additions.


"
Class {
	#name : #GlorpInflectorTest,
	#superclass : #GlorpTestCase,
	#instVars : [
		'inflector'
	],
	#category : #'Glorp-Tests-Tests'
}

{ #category : #'tests-data' }
GlorpInflectorTest >> camelToUnderscoreData [
  ^{
    'Product'               -> 'product'.
    'SpecialGuest'          -> 'special_guest'.
    'ApplicationController' -> 'application_controller'.
    'Area51Controller'      -> 'area51_controller'
  }

  
]

{ #category : #'tests-data' }
GlorpInflectorTest >> camelToUnderscoreWithoutReverse [ 
	^{
    'HTMLTidy'              -> 'html_tidy'.
    'HTMLTidyGenerator'     -> 'html_tidy_generator'.
    'FreeBSD'               -> 'free_bsd'.
    'HTML'                  -> 'html'.
    'ForceXMLController'    -> 'force_xml_controller'.
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> camelWithModuleToUnderscoreWithSlash [ 
	^{
    'Admin::Product' -> 'admin/product'.
    'Users::Commission::Department' -> 'users/commission/department'.
    'UsersSection::CommissionDepartment' -> 'users_section/commission_department'.
  }

  
]

{ #category : #'tests-data' }
GlorpInflectorTest >> classNameToForeignKeyWithUnderscore [ 
	^{
    'Person' -> 'person_id'.
    'MyApplication::Billing::Account' -> 'account_id'
  }

  
]

{ #category : #'tests-data' }
GlorpInflectorTest >> classNameToForeignKeyWithoutUnderscore [ 
	^{
    'Person' -> 'personid'.
    'MyApplication::Billing::Account' -> 'accountid'
  }


]

{ #category : #'tests-data' }
GlorpInflectorTest >> classNameToTableName [ 
	^{
    'PrimarySpokesman' -> 'primary_spokesmen'.
    'NodeChild'        -> 'node_children'
  }

 
]

{ #category : #'tests-data' }
GlorpInflectorTest >> irregularities [ 
	^{
    'person' -> 'people'.
    'man'    -> 'men'.
    'child'  -> 'children'.
    'sex'    -> 'sexes'.
    'move'   -> 'moves'.
    'cow'    -> 'kine'. "Test inflections with different starting letters"
    'zombie' -> 'zombies'.
    'genus'  -> 'genera'
  } 

]

{ #category : #'tests-data' }
GlorpInflectorTest >> mixtureToTitleCase [ 
	^{
    'active_record'         -> 'Active Record'.
    'ActiveRecord'          -> 'Active Record'.
    'action web service'    -> 'Action Web Service'.
    'Action Web Service'    -> 'Action Web Service'.
    'Action web service'    -> 'Action Web Service'.
    'actionwebservice'      -> 'Actionwebservice'.
    'Actionwebservice'      -> 'Actionwebservice'.
    'david''s code'          -> 'David''s Code'.
    'David''s code'          -> 'David''s Code'.
    'david''s Code'          -> 'David''s Code'.
    'sgt. pepper''s'         -> 'Sgt. Pepper''s'.
    'i''ve just seen a face' -> 'I''ve Just Seen A Face'.
    'maybe you''ll be there' -> 'Maybe You''ll Be There'.
    '¿por qué?'             -> '¿Por Qué?'.
    'Fred’s'                -> 'Fred’s'.
    'Fred`s'                -> 'Fred`s'.
    'this was ''fake news'''  -> 'This Was ''Fake News'''
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> mixtureToTitleCaseWithKeepIdSuffix [ 
	^{
    'this_is_a_string_ending_with_id' -> 'This Is A String Ending With Id'.
    'EmployeeId'                      -> 'Employee Id'.
    'Author Id'                       -> 'Author Id'
  }

 
]

{ #category : #'tests-data' }
GlorpInflectorTest >> ordinalNumbers [ 
	^{
    '-1' -> '-1st'.
    '-2' -> '-2nd'.
    '-3' -> '-3rd'.
    '-4' -> '-4th'.
    '-5' -> '-5th'.
    '-6' -> '-6th'.
    '-7' -> '-7th'.
    '-8' -> '-8th'.
    '-9' -> '-9th'.
    '-10' -> '-10th'.
    '-11' -> '-11th'.
    '-12' -> '-12th'.
    '-13' -> '-13th'.
    '-14' -> '-14th'.
    '-20' -> '-20th'.
    '-21' -> '-21st'.
    '-22' -> '-22nd'.
    '-23' -> '-23rd'.
    '-24' -> '-24th'.
    '-100' -> '-100th'.
    '-101' -> '-101st'.
    '-102' -> '-102nd'.
    '-103' -> '-103rd'.
    '-104' -> '-104th'.
    '-110' -> '-110th'.
    '-111' -> '-111th'.
    '-112' -> '-112th'.
    '-113' -> '-113th'.
    '-1000' -> '-1000th'.
    '-1001' -> '-1001st'.
    '0' -> '0th'.
    '1' -> '1st'.
    '2' -> '2nd'.
    '3' -> '3rd'.
    '4' -> '4th'.
    '5' -> '5th'.
    '6' -> '6th'.
    '7' -> '7th'.
    '8' -> '8th'.
    '9' -> '9th'.
    '10' -> '10th'.
    '11' -> '11th'.
    '12' -> '12th'.
    '13' -> '13th'.
    '14' -> '14th'.
    '20' -> '20th'.
    '21' -> '21st'.
    '22' -> '22nd'.
    '23' -> '23rd'.
    '24' -> '24th'.
    '100' -> '100th'.
    '101' -> '101st'.
    '102' -> '102nd'.
    '103' -> '103rd'.
    '104' -> '104th'.
    '110' -> '110th'.
    '111' -> '111th'.
    '112' -> '112th'.
    '113' -> '113th'.
    '1000' -> '1000th'.
    '1001' -> '1001st'
  }

]

{ #category : #running }
GlorpInflectorTest >> setUp [ 
	super setUp.
	inflector := GlorpInflector new.
	
]

{ #category : #'tests-data' }
GlorpInflectorTest >> singularToPluralData [

  ^{
    'search'      -> 'searches'.
    'switch'      -> 'switches'.
    'fix'         -> 'fixes'.
    'box'         -> 'boxes'.
    'process'     -> 'processes'.
    'address'     -> 'addresses'.
    'case'        -> 'cases'.
    'stack'       -> 'stacks'.
    'wish'        -> 'wishes'.
    'fish'        -> 'fish'.
    'jeans'       -> 'jeans'.
    'funky jeans' -> 'funky jeans'.
    'my money'    -> 'my money'.

    'category'    -> 'categories'.
    'query'       -> 'queries'.
    'ability'     -> 'abilities'.
    'agency'      -> 'agencies'.
    'movie'       -> 'movies'.

    'archive'     -> 'archives'.

    'index'       -> 'indices'.

    'wife'        -> 'wives'.
    "'safe'        -> 'saves'."
    'half'        -> 'halves'.

    'move'        -> 'moves'.

    'salesperson' -> 'salespeople'.
    'person'      -> 'people'.

    'spokesman'   -> 'spokesmen'.
    'man'         -> 'men'.
    'woman'       -> 'women'.

    'basis'       -> 'bases'.
    'diagnosis'   -> 'diagnoses'.
    'diagnosis_a' -> 'diagnosis_as'.

    'datum'       -> 'data'.
    'medium'      -> 'media'.
    'stadium'     -> 'stadia'.
    'analysis'    -> 'analyses'.
    'my_analysis' -> 'my_analyses'.

    'node_child'  -> 'node_children'.
    'child'       -> 'children'.

    'experience'  -> 'experiences'.
    'day'         -> 'days'.

    'comment'     -> 'comments'.
    'foobar'      -> 'foobars'.
    'newsletter'  -> 'newsletters'.

    'old_news'    -> 'old_news'.
    'news'        -> 'news'.

    'series'      -> 'series'.
    'miniseries'  -> 'miniseries'.
    'species'     -> 'species'.

    'quiz'        -> 'quizzes'.

    'perspective' -> 'perspectives'.

    'ox'          -> 'oxen'.
    'photo'       -> 'photos'.
    'buffalo'     -> 'buffaloes'.
    'tomato'      -> 'tomatoes'.
    'dwarf'       -> 'dwarves'.
    'elf'         -> 'elves'.
    'information' -> 'information'.
    'equipment'   -> 'equipment'.
    'bus'         -> 'buses'.
    'status'      -> 'statuses'.
    'status_code' -> 'status_codes'.
    'mouse'       -> 'mice'.

    'louse'       -> 'lice'.
    'house'       -> 'houses'.
    'octopus'     -> 'octopi'.
    'virus'       -> 'viri'.
    'alias'       -> 'aliases'.
    'portfolio'   -> 'portfolios'.

    'vertex'      -> 'vertices'.
    'matrix'      -> 'matrices'.
    'matrix_fu'   -> 'matrix_fus'.

    'axis'        -> 'axes'.
    'taxi'        -> 'taxis'. "prevents regression"
    'testis'      -> 'testes'.
    'crisis'      -> 'crises'.

    'rice'        -> 'rice'.
    'shoe'        -> 'shoes'.

    'horse'       -> 'horses'.
    'prize'       -> 'prizes'.
    'edge'        -> 'edges'.

    'database'    -> 'databases'.
	'metadata' -> 'metadata'.

    "regression tests against improper inflection regexes"
    '|ice'        -> '|ices'.
    '|ouse'       -> '|ouses'.
    'slice'       -> 'slices'.
    'police'      -> 'police'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterizePreserveCaseWithNoSeparator [ 
	^{
    'Donald E. Knuth'                     -> 'DonaldEKnuth'.
    'With-some-dashes'                    -> 'With-some-dashes'.
    'Random text with *(bad)* characters' -> 'Randomtextwithbadcharacters'.
    'Trailing bad characters!@#'          -> 'Trailingbadcharacters'.
    '!@#Leading bad characters'           -> 'Leadingbadcharacters'.
    'Squeeze   separators'                -> 'Squeezeseparators'.
    'Test with + sign'                    -> 'Testwithsign'.
    'Test with malformed utf8 \xA9'       -> 'Testwithmalformedutf8'
  }


]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterizePreserveCaseWithUnderscore [ 
	^{
    'Donald E. Knuth'                     -> 'Donald_E_Knuth'.
    'Random text with *(bad)* characters' -> 'Random_text_with_bad_characters'.
    'With-some-dashes'                    -> 'With-some-dashes'.
    'Allow_Under_Scores'                  -> 'Allow_Under_Scores'.
    'Trailing bad characters!@#'          -> 'Trailing_bad_characters'.
    '!@#Leading bad characters'           -> 'Leading_bad_characters'.
    'Squeeze   separators'                -> 'Squeeze_separators'.
    'Test with + sign'                    -> 'Test_with_sign'.
    'Test with malformed utf8 \xA9'       -> 'Test_with_malformed_utf8'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterizeWithNoSeparator [ 
	^{
    'Donald E. Knuth'                     -> 'donaldeknuth'.
    'With-some-dashes'                    -> 'with-some-dashes'.
    'Random text with *(bad)* characters' -> 'randomtextwithbadcharacters'.
    'Trailing bad characters!@#'          -> 'trailingbadcharacters'.
    '!@#Leading bad characters'           -> 'leadingbadcharacters'.
    'Squeeze   separators'                -> 'squeezeseparators'.
    'Test with + sign'                    -> 'testwithsign'.
    'Test with malformed utf8 \251'       -> 'testwithmalformedutf8'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterizeWithUnderscore [ 
	^{
    'Donald E. Knuth'                     -> 'donald_e_knuth'.
    'Random text with *(bad)* characters' -> 'random_text_with_bad_characters'.
    'With-some-dashes'                    -> 'with-some-dashes'.
    'Retain_underscore'                   -> 'retain_underscore'.
    'Trailing bad characters!@#'          -> 'trailing_bad_characters'.
    '!@#Leading bad characters'           -> 'leading_bad_characters'.
    'Squeeze   separators'                -> 'squeeze_separators'.
    'Test with + sign'                    -> 'test_with_sign'.
    'Test with malformed utf8 \251'       -> 'test_with_malformed_utf8'
  }

 
]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterized [ 
	^{
    'Donald E. Knuth'                     -> 'donald-e-knuth'.
    'Random text with *(bad)* characters' -> 'random-text-with-bad-characters'.
    'Allow_Under_Scores'                  -> 'allow_under_scores'.
    'Trailing bad characters!@#'          -> 'trailing-bad-characters'.
    '!@#Leading bad characters'           -> 'leading-bad-characters'.
    'Squeeze   separators'                -> 'squeeze-separators'.
    'Test with + sign'                    -> 'test-with-sign'.
    'Test with malformed utf8 \251'       -> 'test-with-malformed-utf8'
  }
]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterizedAndNormalized [ 
	^{
    'Malmö'                               -> 'malmo'.
    'Garçons'                             -> 'garcons'.
    'Ops\331'                             -> 'opsu'.
    'Ærøskøbing'                          -> 'aeroskobing'.
    'Aßlar'                               -> 'asslar'.
    'Japanese: 日本語' -> 'japanese'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> stringToParameterizedPreserveCase [ 
	^{
    'Donald E. Knuth'                     -> 'Donald-E-Knuth'.
    'Random text with *(bad)* characters' -> 'Random-text-with-bad-characters'.
    'Allow_Under_Scores'                  -> 'Allow_Under_Scores'.
    'Trailing bad characters!@#'          -> 'Trailing-bad-characters'.
    '!@#Leading bad characters'           -> 'Leading-bad-characters'.
    'Squeeze   separators'                -> 'Squeeze-separators'.
    'Test with + sign'                    -> 'Test-with-sign'.
    'Test with malformed utf8 \xA9'       -> 'Test-with-malformed-utf8'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> symbolToLowerCamelData [
	^{
    #product -> 'product'.
    #special_guest -> 'specialGuest'.
    #application_controller -> 'applicationController'.
    #area51_controller -> 'area51Controller'
  }

 
]

{ #category : #running }
GlorpInflectorTest >> testPluralToSingular [

	self singularToPluralData do: [ :ea |
		self 
			assert: (inflector singularize: ea value) 
			equals: ea key 
		]
		
]

{ #category : #running }
GlorpInflectorTest >> testSingularToPlural [

	self singularToPluralData do: [ :ea |
		self 
			assert: (inflector pluralize: ea key) 
			equals: ea value 
		]
		
]

{ #category : #'tests-data' }
GlorpInflectorTest >> underscoreToHuman [ 
	^{
    'employee_salary' -> 'Employee salary'.
    'employee_id'     -> 'Employee'.
    'underground'     -> 'Underground'.
    '_id'             -> 'Id'.
    '_external_id'    -> 'External'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> underscoreToHumanWithKeepIdSuffix [ 
	^{
    'this_is_a_string_ending_with_id' -> 'This is a string ending with id'.
    'employee_id'                -> 'Employee id'.
    'employee_id_something_else' -> 'Employee id something else'.
    'underground'               -> 'Underground'.
    '_id'                       -> 'Id'.
    '_external_id'              -> 'External id'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> underscoreToHumanWithoutCapitalize [ 
	^{
    'employee_salary' -> 'employee salary'.
    'employee_id'     -> 'employee'.
    'underground'     -> 'underground'
  }

]

{ #category : #'tests-data' }
GlorpInflectorTest >> underscoreToLowerCamelData [ 
^{
    'product'                -> 'product'.
    'special_guest'          -> 'specialGuest'.
    'application_controller' -> 'applicationController'.
    'area51_controller'      -> 'area51Controller'
  }


]

{ #category : #'tests-data' }
GlorpInflectorTest >> underscoresToDashes [ 
	^{
    'street'                -> 'street'.
    'street_address'        -> 'street-address'.
    'person_street_address' -> 'person-street-address'
  }

]
