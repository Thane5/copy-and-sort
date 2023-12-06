extends VBoxContainer

var sourceFolderPath = "nullstring"
var targetFolderPath = "nullstring"
@export var sourceFileDialog: FileDialog
@export var targetFileDialog: FileDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	_check_source_path_existence()
	_check_target_path_existence()

func _on_set_source_pressed():
	sourceFileDialog.show()
	
func _on_set_target_pressed():
	targetFileDialog.show()


func _on_file_dialog_source_dir_selected(dir):
	sourceFolderPath = dir
	print("Source folder: " + sourceFolderPath)
	%SourcePathDisplay.text = sourceFolderPath
	_check_source_path_existence()
	var fileCountInSource = DirAccess.get_files_at(sourceFolderPath).size()
	print(str(fileCountInSource) + " Files found in " + sourceFolderPath)
	#%"Copy Button".text = "Copy " + str(fileCountInSource) + " Files"
	update_copy_button()
	%SettingsManager.save_settings()


func _on_file_dialog_target_dir_selected(dir):
	targetFolderPath = dir
	print("Target folder: " + targetFolderPath)
	%TargetPathDisplay.text = targetFolderPath
	_check_target_path_existence()
	update_copy_button()
	%SettingsManager.save_settings()


	
func _check_source_path_existence():
	if DirAccess.dir_exists_absolute(sourceFolderPath):
		%SourcePathCheck.button_pressed = true
	else:
		%SourcePathCheck.button_pressed = false
		%SourcePathDisplay.text = "-"

	
func _check_target_path_existence():
	if DirAccess.dir_exists_absolute(targetFolderPath):
		%TargetPathCheck.button_pressed = true
	else:
		%TargetPathCheck.button_pressed = false

func update_copy_button():
	var sourceExists = DirAccess.dir_exists_absolute(sourceFolderPath)
	var targetExists = DirAccess.dir_exists_absolute(targetFolderPath)
	if sourceExists and targetExists:
		%"Copy Button".disabled = false
		print("Button can now be used")
	else:
		%"Copy Button".disabled = true
