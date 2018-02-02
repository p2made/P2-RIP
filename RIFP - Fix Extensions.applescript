(* INSTRUCTIONS
This droplet is designed to process one or more files, or folders containing files, whose icons are dragged onto the droplet icon.
The droplet processes recursively, and will examine the contents of every folder and every sub-folder within those folders, to find and process any appropriate files found.
To use, replace the example processing code in the process_item sub-routine with your code. Save as an application.
*)

(* TO FILTER FOR IMAGE FILES, LOOK FOR QUICKTIME SUPPORTED IMAGE FORMATS *)
property typeList : {"JPEG", "TIFF", "PNGf", "8BPS", "BMPf", "GIFf", "PDF ", "PICT"}
property extensionList : {"jpg", "jpeg", "tif", "tiff", "png", "psd", "bmp", "gif", "jp2", "pdf", "pict", "pct", "sgi", "tga"}
property typeIdsList : {"public.jpeg", "public.tiff", "public.png", "com.adobe.photoshop-image", "com.microsoft.bmp", "com.compuserve.gif", "public.jpeg-2000", "com.adobe.pdf", "com.apple.pict", "com.sgi.sgi-image", "com.truevision.tga-image"}

on run {input}
	repeat with i from 1 to the count of input
		set thisItem to item i of input
		set the itemInfo to info for thisItem without size
		if folder of the itemInfo is true then
			processFolder(thisItem)
		else
			preProcessItem(thisItem, itemInfo)
		end if
	end repeat
	
	return input
end run

-- this sub-routine processes folders
on processFolder(thisFolder)
	set theseItems to list folder thisFolder without invisibles
	repeat with i from 1 to the count of theseItems
		set thisItem to alias ((thisFolder as Unicode text) & (item i of theseItems))
		set the itemInfo to info for thisItem without size
		if folder of the itemInfo is true then
			processFolder(thisItem)
		else
			preProcessItem(thisItem, itemInfo)
		end if
	end repeat
end processFolder

-- this sub-routine pre-processes the item
on preProcessItem(thisItem, itemInfo)
	try
		set thisExtension to the name extension of itemInfo
	on error
		set thisExtension to ""
	end try
	try
		set thisFileType to the file type of itemInfo
	on error
		set thisFileType to ""
	end try
	try
		set thisTypeId to the type identifier of itemInfo
	on error
		set thisTypeId to ""
	end try
	
	if (folder of the itemInfo is false) and (package folder of the itemInfo is false) and (alias of the itemInfo is false) then
		set infoCheck to true
	end if
	if (thisFileType is in the typeList) or (thisExtension is in the extensionList) or (thisTypeId is in typeIdsList) then
		set listCheck to true
	end if
	
	if (infoCheck is true) and (listCheck is true) then
		processFile(thisItem)
	end if
end preProcessItem

-- this sub-routine processes files
on processFile(thisItem)
	-- NOTE that the variable thisItem is a file reference in alias format
	try
		tell application "Image Events"
			-- start the Image Events application
			launch
			-- open the image file
			set thisImage to open thisItem
			-- get the dimensions
			set imageDImensions to dimensions of thisImage
			-- save the save the image to give it an icon
			save thisImage with icon
			-- purge the open image data
			close thisImage
		end tell
	on error error_message number error_number
		display alert "PROCESSING ERROR getting dimensions:" & error_number message error_message as warning buttons {"Cancel"} cancel button "Cancel"
	end try
	
	try
		set imageWidth to setDimension(item 1 of imageDImensions as integer)
	on error error_message number error_number
		display alert "PROCESSING ERROR setting image width:" & error_number message error_message as warning buttons {"Cancel"} cancel button "Cancel"
	end try
	try
		set imageHeight to setDimension(item 2 of imageDImensions as integer)
	on error error_message number error_number
		display alert "PROCESSING ERROR setting image height:" & error_number message error_message as warning buttons {"Cancel"} cancel button "Cancel"
	end try
	
	try
		tell application "Finder"
			set theFile to file thisItem
			try
				set oldFilename to name of theFile
				set newFilename to imageWidth & "x" & imageHeight & " " & oldFilename
				set name of theFile to newFilename
			end try
		end tell
	on error error_message number error_number
		display alert "PROCESSING ERROR setting filename:" & error_number message error_message as warning buttons {"Cancel"} cancel button "Cancel"
	end try
	
	
	-- NOTE that the variable this_item is a file reference in alias format 
	-- PUT YOUR FILE PROCESSING STATEMENTS HERE 
	(* Example routine for rotating image counter-clockwise using the Image Events application:
	try
		tell application "Image Events"
			-- start the Image Events application
			launch
			-- open the image file
			set this_image to open this_item
			-- perform action
			rotate this_image to angle 270 
			-- save the changes
			save this_image with icon
			-- purge the open image data
			close this_image
		end tell
	on error error_message number error_number
		display alert "PROCESSING ERROR " & error_number message error_message as warning buttons {"Cancel"} cancel button "Cancel"
	end try
	*)
end processFile

-- this sub-routine sets image dimensions as strings
on setDimension(theNumber)
	try
		if theNumber < 1000 then
			set theString to "0" & (theNumber as string)
		else
			set theString to (theNumber as string)
		end if
		return theNumber as string
	on error error_message number error_number
		display alert "PROCESSING ERROR setting dimension string:" & error_number message error_message as warning buttons {"Cancel"} cancel button "Cancel"
	end try
end setDimension
