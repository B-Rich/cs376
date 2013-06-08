require 'evernote_oauth'
class ApiController < ApplicationController
	def createNote
		#TODO: Include photo and video. Document parameters

	    title = params[:title] ? params[:title] : "New Note"
	    content = params[:content] ? params[:content] : ""
		tagNames = params[:tagNames] ? params[:tagNames].split(',') : []
		notebookName = params[:notebookName] ? params[:notebookName] : ""
		
			note = Evernote::EDAM::Type::Note.new(
			  title: title,
			  tagNames: tagNames,
			  content: '<?xml version="1.0" encoding="UTF-8"?>'+'<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'+'<en-note>'+content+'</en-note>',
			)
		client = EvernoteOAuth::Client.new(token: session[:authtoken])
	    note_store = client.note_store
		notebooks = note_store.listNotebooks
		notebookGuid = defaultNotebookGuid(notebooks)
		notebooks.each do |notebook|
			if notebook.name == notebookName
				notebookGuid = notebook.guid
			end
		end

		#begin
			# note = Evernote::EDAM::Type::Note.new(
			#   title: title,
			#   tagNames: tagNames,
			#   content: '<?xml version="1.0" encoding="UTF-8"?>'+'<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'+'<en-note>'+content+'</en-note>',
			#   notebookGuid: notebookGuid 
			# )
			created_note = note_store.createNote(session[:authtoken], note)
		#rescue Evernote::EDAM::Error::EDAMUserException => e
		#	render(:partial=>"display_error", :locals=>{:error_message=>translate_error(e)})	
		#end
	end

	#Returns JSON array of notebook names
	def listNotebooks
		client = EvernoteOAuth::Client.new(token: session[:authtoken])
	    note_store = client.note_store
    	@notebooks = note_store.listNotebooks

	end

	#Stub method:To all notes containing tagX, assign them tagY. Optional replace parameter

	#Helper methods (put it in helpers folder but didn't work for some reason.)
	def defaultNotebookGuid(notebooks)
		notebooks.each do |notebook|
			if notebook.defaultNotebook?
				return notebook.guid 
			end
		end
		return -1
	end


	def translate_error(e)
		error_name = "unknown"
		case e.errorCode
		when Evernote::EDAM::Error::EDAMErrorCode::AUTH_EXPIRED
		  error_name = "AUTH_EXPIRED"
		when Evernote::EDAM::Error::EDAMErrorCode::BAD_DATA_FORMAT
		  error_name = "BAD_DATA_FORMAT"
		when Evernote::EDAM::Error::EDAMErrorCode::DATA_CONFLICT
		  error_name = "DATA_CONFLICT"
		when Evernote::EDAM::Error::EDAMErrorCode::DATA_REQUIRED
		  error_name = "DATA_REQUIRED"
		when Evernote::EDAM::Error::EDAMErrorCode::ENML_VALIDATION
		  error_name = "ENML_VALIDATION"
		when Evernote::EDAM::Error::EDAMErrorCode::INTERNAL_ERROR
		  error_name = "INTERNAL_ERROR"
		when Evernote::EDAM::Error::EDAMErrorCode::INVALID_AUTH
		  error_name = "INVALID_AUTH"
		when Evernote::EDAM::Error::EDAMErrorCode::LIMIT_REACHED
		  error_name = "LIMIT_REACHED"
		when Evernote::EDAM::Error::EDAMErrorCode::PERMISSION_DENIED
		  error_name = "PERMISSION_DENIED"
		when Evernote::EDAM::Error::EDAMErrorCode::QUOTA_REACHED
		  error_name = "QUOTA_REACHED"
		when Evernote::EDAM::Error::EDAMErrorCode::SHARD_UNAVAILABLE
		  error_name = "SHARD_UNAVAILABLE"
		when Evernote::EDAM::Error::EDAMErrorCode::UNKNOWN
		  error_name = "UNKNOWN"
		when Evernote::EDAM::Error::EDAMErrorCode::VALID_VALUES
		  error_name = "VALID_VALUES"
		when Evernote::EDAM::Error::EDAMErrorCode::VALUE_MAP
		  error_name = "VALUE_MAP"
		end
		rv = "Error code was: #{error_name}[#{e.errorCode}] and parameter: [#{e.parameter}]"  
	end

end