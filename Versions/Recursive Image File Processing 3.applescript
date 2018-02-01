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
	tell application "Image Events"
		launch
		set thisImage to open thisItem
		set imageDimensions to dimensions of thisImage
		close thisImage
		
		set theString to setDimension(item 1 of imageDimensions as number)
		
		set filenamePrefix to ((item 1 of imageDimensions as string) & "x" & item 2 of imageDimensions as string) & " "
		quit
	end tell
	
	
	tell application "Finder"
		set theFile to file thisItem
		try
			set oldFilename to name of theFile
			set newFilename to filenamePrefix & oldFilename
			set name of theFile to newFilename
		end try
	end tell
end processFile

-- this sub-routine sets image dimensions as strings
on setDimension(theNumber)
	(*
	if theNumber < 100 then
		set theString to "00" & (theNumber as string)
	else if theNumber < 1000 then
		set theString to "0" & (theNumber as string)
	else
		set theString to (theNumber as string)
	end if
	return
	*)
	return theNumber as string
end setDimension
