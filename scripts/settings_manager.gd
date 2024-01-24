extends Node

var settingsPath = "user://settings.json"

var settingsDict = []
var jsonString
var settingsFile
# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists(settingsPath):
		print("no settings file found, restoring defaults")
		_restore_default_settings()
		
#		var jsonString = FileAccess.get_file_as_string(settingsPath)
#		settingsFile = FileAccess.open(settingsPath, FileAccess.WRITE)

		
	jsonString = FileAccess.get_file_as_string(settingsPath)
	#settingsFile = FileAccess.open(settingsPath, FileAccess.WRITE)
	
	settingsDict = JSON.parse_string(jsonString)

	%"Path Manager".sourceFolderPath = settingsDict.sourceFolderPath
	%SourcePathDisplay.text = settingsDict.sourceFolderPath
	%"Path Manager".targetFolderPath = settingsDict.targetFolderPath
	%TargetPathDisplay.text = settingsDict.targetFolderPath
#		if settings.sourceFolderPath != null:
#			pass
	print("Value sourceFolderPath found")
	
	%"Path Manager".update_copy_button()


func save_settings():
	settingsFile = FileAccess.open(settingsPath, FileAccess.WRITE)
#	print("trying to save " + %"Path Manager".sourceFolderPath)
#	print("trying to save " + %"Path Manager".targetFolderPath)
	settingsDict = {
		"sourceFolderPath" : %"Path Manager".sourceFolderPath,
		"targetFolderPath" : %"Path Manager".targetFolderPath
	}
	jsonString = JSON.stringify(settingsDict)
	print(jsonString)
	settingsFile.store_string(jsonString)
	settingsFile.close()

func _restore_default_settings():
	settingsFile = FileAccess.open(settingsPath, FileAccess.WRITE)
	
	settingsDict = {
		"sourceFolderPath" : "none selected",
		"targetFolderPath" : "none selected"
	}
	jsonString = JSON.stringify(settingsDict)
	print(jsonString)
	settingsFile.store_string(jsonString)
	settingsFile.close()
	
	
