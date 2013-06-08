module ApplicationHelper

  # These methods are not available to third party applications
  UNAVAILABLE_METHODS = [:authenticate, :authenticateLongSession, :refreshAuthentication, :emailNote, :expungeInactiveNotes,
    :expungeLinkedNotebook, :expungeNote, :expungeNotebook, :expungeNotes, :expungeSearch,
    :expungeSharedNotebooks, :expungeTag, :getAccountSize, :getAds, :getRandomAd]

  def link_to_user_store(method_name)
    link_to link_body(method_name), user_store_path(method: method_name),
      :id => "user_store_#{method_name}"
  end

  def link_to_note_store(method_name)
    link_to link_body(method_name), note_store_path(method: method_name),
      :id => "note_store_#{method_name}"
  end

  def link_to_advanced(method_name)
    link_to method_name.to_s.titleize, advanced_path(method: method_name),
      :id => "advanced_#{method_name}"
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

  def defaultNotebookGuid(notebooks)
    notebooks.each do |notebook|
      if notebook.defaultNotebook?
        return notebook.guid 
      end
    end
    return -1
  end
  
  private
  # Show the 'unavailable' label
  def link_body(method_name)
    "#{('[UNAVAILABLE] ' if UNAVAILABLE_METHODS.include?(method_name))}#{method_name}"
  end

end
