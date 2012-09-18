require 'data_mapper' unless defined?DataMapper

module Model
  #
  # Log record (simple logger record which holds all the message in)
  #
  class LogRecord
      include DataMapper::Resource

      storage_names[:default] = 'system_log_record'
      
      property :id, Serial, :key => true
      property :thread, String, :field => 'thread', :length => 32
      property :message, Text, :field => 'message'
  
  end #LogRecord
end #Model