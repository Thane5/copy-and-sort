extends Button

var sourceFileArray = []
var copiedFilesArray = []


var continueCopying = false
var fileNumber = 0

var logMessage

# Called when the node enters the scene tree for the first time.
func _process(delta):
	%"Copy Button".disabled = continueCopying
	%"Set Source".disabled = continueCopying
	%"Set Target".disabled = continueCopying
	
	if continueCopying:
		var currentFile = sourceFileArray[fileNumber]
		
		# here is say "fileNumber+1" because the displayed counter should start at 1
		var statusText = "Processing file " + str(fileNumber+1) + " of " + str(sourceFileArray.size())
		print(statusText)

		%"Copy Button".text = statusText
		
		# Copy the selected file
		_copy_file_to_target(currentFile)
		
		
		
		if fileNumber+1 == sourceFileArray.size():
			#print("All files copied")
			continueCopying = false
			fileNumber = 0
			copiedFilesArray = []
			%LogArea.text = logMessage
		else:
			#print("not all files processed, continuing")
			continueCopying = true
			fileNumber = fileNumber+1
	else:
		%"Copy Button".text = "Copy Files"



func _on_pressed():
	%LogArea.clear()
	
	var sourceExists = DirAccess.dir_exists_absolute(%"Path Manager".sourceFolderPath)
	var targetExists = DirAccess.dir_exists_absolute(%"Path Manager".targetFolderPath)
	
	if !sourceExists:
		
		logMessage = "Error - Source folder not found: " + %"Path Manager".sourceFolderPath
		print(logMessage)
		%LogArea.text = logMessage
		
	if !targetExists:
		logMessage = "Error - Target folder not found: " + %"Path Manager".targetFolderPath
		print(logMessage)
		%LogArea.text = logMessage
	
	if sourceExists and targetExists:
		sourceFileArray = DirAccess.get_files_at(%"Path Manager".sourceFolderPath)
		
		continueCopying = true

func _copy_file_to_target(file):
	var sourceFilePath = %"Path Manager".sourceFolderPath + "/" + file
			
	# Construct the string for the Year/month subfolders
	var dateModified = FileAccess.get_modified_time(sourceFilePath)
	var datestring = Time.get_date_string_from_unix_time(dateModified)
	var folderStructure ="/" + datestring.replace("-", "/").left(8)


	var targetFolderPath = %"Path Manager".targetFolderPath
	var targetFilePath = targetFolderPath + folderStructure + file

	
	# Only copy proceed if the file doesnt already exist
	if FileAccess.file_exists(targetFilePath):
		print("This file already exists at target and will be skipped: " + targetFilePath)
	else:
		# Check if the folder structure exists
		if !DirAccess.dir_exists_absolute(targetFolderPath + folderStructure):
			DirAccess.make_dir_recursive_absolute(targetFolderPath + folderStructure)
			print("Created Folder: " + targetFolderPath + folderStructure)
		
		# Copy the file
		DirAccess.copy_absolute(sourceFilePath, targetFilePath)
		copiedFilesArray.append(file)
		
		
	var filesAnalysedCount = str(sourceFileArray.size())
	var skippedFilesCount = str(sourceFileArray.size() - copiedFilesArray.size())
	var copiedFilesCount = str(copiedFilesArray.size())
	
	logMessage = filesAnalysedCount + " files found on source. " + skippedFilesCount + " of them already exist on target. " + copiedFilesCount + " files copied: " + str(copiedFilesArray)
	print(logMessage)
	# Set log text
	#%LogArea.text = logMessage
