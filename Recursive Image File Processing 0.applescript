(* INSTRUCTIONS
This droplet is designed to process one or more files, or folders containing files, whose icons are dragged onto the droplet icon.
The droplet processes recursively, and will examine the contents of every folder and every sub-folder within those folders, to find and process any appropriate files found.
To use, replace the example processing code in the process_item sub-routine with your code. Save as an application.
*)

(* TO FILTER FOR IMAGE FILES, LOOK FOR QUICKTIME SUPPORTED IMAGE FORMATS *)
property type_list : {"JPEG", "TIFF", "PNGf", "8BPS", "BMPf", "GIFf", "PDF ", "PICT"}
property extension_list : {"jpg", "jpeg", "tif", "tiff", "png", "psd", "bmp", "gif", "jp2", "pdf", "pict", "pct", "sgi", "tga"}
property typeIDs_list : {"public.jpeg", "public.tiff", "public.png", "com.adobe.photoshop-image", "com.microsoft.bmp", "com.compuserve.gif", "public.jpeg-2000", "com.adobe.pdf", "com.apple.pict", "com.sgi.sgi-image", "com.truevision.tga-image"}

-- This droplet processes files dropped onto the applet 
on open these_items
	-- FILTER THE DRAGGED-ON ITEMS BY CHECKING THEIR PROPERTIES AGAINST THE LISTS ABOVE
	repeat with i from 1 to the count of these_items
		set this_item to item i of these_items
		set the item_info to info for this_item without size
		if folder of the item_info is true then
			process_folder(this_item)
		else
			try
				set this_extension to the name extension of item_info
			on error
				set this_extension to ""
			end try
			try
				set this_filetype to the file type of item_info
			on error
				set this_filetype to ""
			end try
			try
				set this_typeID to the type identifier of item_info
			on error
				set this_typeID to ""
			end try
			if (folder of the item_info is false) and (alias of the item_info is false) and ((this_filetype is in the type_list) or (this_extension is in the extension_list) or (this_typeID is in typeIDs_list)) then
				-- THE ITEM IS AN IMAGE FILE AND CAN BE PROCESSED
				process_item(this_item)
			end if
		end if
	end repeat
end open

-- this sub-routine processes folders 
on process_folder(this_folder)
	set these_items to list folder this_folder without invisibles
	repeat with i from 1 to the count of these_items
		set this_item to alias ((this_folder as Unicode text) & (item i of these_items))
		set the item_info to info for this_item without size
		if folder of the item_info is true then
			process_folder(this_item)
		else
			try
				set this_extension to the name extension of item_info
			on error
				set this_extension to ""
			end try
			try
				set this_filetype to the file type of item_info
			on error
				set this_filetype to ""
			end try
			try
				set this_typeID to the type identifier of item_info
			on error
				set this_typeID to ""
			end try
			if (folder of the item_info is false) and (alias of the item_info is false) and ((this_filetype is in the type_list) or (this_extension is in the extension_list) or (this_typeID is in typeIDs_list)) then
				-- THE ITEM IS AN IMAGE FILE AND CAN BE PROCESSED
				process_item(this_item)
			end if
		end if
	end repeat
end process_folder

-- this sub-routine processes files 
on process_item(this_item)
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
end process_item
