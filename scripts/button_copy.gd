extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	var sourceExists = DirAccess.dir_exists_absolute(%"Path Manager".sourceFolderPath)
	var targetExists = DirAccess.dir_exists_absolute(%"Path Manager".targetFolderPath)
	
	if !sourceExists:
		print("Error with source folder:" + %"Path Manager".sourceFolderPath)
		
	if !targetExists:
		print("Error with target folder:" + %"Path Manager".targetFolderPath)
	
	if sourceExists and targetExists:
		var fileArray = DirAccess.get_files_at(%"Path Manager".sourceFolderPath)
		var copiedFilesArray = []

		for file in fileArray:
			var sourceFilePath = %"Path Manager".sourceFolderPath + "/" + file
			
			# Construct the string for the Year/month subfolders
			var dateModified = FileAccess.get_modified_time(sourceFilePath)
			var datestring = Time.get_date_string_from_unix_time(dateModified)
			var folderStructure ="/" + datestring.replace("-", "/").left(8)
		
		
			var targetFolderPath = %"Path Manager".targetFolderPath
			var targetFilePath = targetFolderPath + folderStructure + file
		
			
			# Only copy proceed if the file doesnt already exist
			if FileAccess.file_exists(targetFilePath):
				print("This file already exists and will be skipped: " + targetFilePath)
			else:
				# Check if the folder structure exists
				if !DirAccess.dir_exists_absolute(targetFolderPath + folderStructure):
					DirAccess.make_dir_recursive_absolute(targetFolderPath + folderStructure)
					print("Created Folder: " + targetFolderPath + folderStructure)
				
				# Copy the file
				DirAccess.copy_absolute(sourceFilePath, targetFilePath)
				copiedFilesArray.append(file)
				
			# Set log text
			%LogArea.text = str(copiedFilesArray.size()) + " Files copied: " + str(copiedFilesArray)
			
			#text = "Copy 0 Files"
			

