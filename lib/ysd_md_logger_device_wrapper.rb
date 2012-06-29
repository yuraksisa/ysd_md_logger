require 'singleton'
require 'datamapper' unless defined?DataMapper

module Model

  #
  # LogDevice inverse proxy allows to publish a log message to some log devices
  #
  # Usage:
  #
  #   Model::LogDeviceInverseProxy.instance.register_logdevice($stdout)
  #   Model::LogDeviceInverseProxy.instance.register_logdevice(File.new('./log.log'))
  #
  #   And then asign it as a logger device
  #   
  #   logger = ::Logger.new(Model::LogDeviceInverseProxy.instance)
  #
  #   So, when we log, it reproduces the message to all the 'proxied' devices
  #
  #   logger.debug('Process done')
  #
  #
  class LogDeviceInverseProxy
        include Singleton
    
    def initialize  
      @log_devices = []
    end
    
    #
    # Register a log device
    #
    def register_logdevice(log_device)
      @log_devices << log_device      
    end
    
    #
    # Write a message to all registered log devices
    #
    def write(message)
    
      @log_devices.each do |log_device|
        puts "Writing message on #{log_device.inspect}"
        log_device.write(message)
        puts "Message writen on #{log_device.inspect}"
      end
    
    end
    
    def close
    
      @log_devices.each do |log_device|
        log_device.close
      end
    
    end
  
  end

  class DataMapperLogDevice
  
    def initialize(repository, insert_sql)
     
     @repository = repository
     @insert_sql = insert_sql
    
    end
  
    def write(message)
    
      if DataMapper.repository(@repository).adapter.respond_to?(:select)
        DataMapper.repository(@repository).adapter.select(@insert_sql, message)
      end
      
    end
    
    def close
    
    end
  
  end

  #
  # It represents a log device which writes the log message to a database
  #
  class LogDevice
    
    def initialize(opts={})
      @max_size = opts[:max_size] || 2000
    end
  
    def write(message)

       check_shift_log
       begin
          LogRecord.create({:thread => Thread.current.inspect.match(/:(\w+)/)[1],
                            :message => message})
      
       rescue 
          puts("Error creating message #{$!}")
       end
      
    end
    
    def close
    
    end
  
    private
    
    def check_shift_log
      
      if LogRecord.count == @max_size 
        LogRecord.all({:order => [:id.asc], :limit =>1}).destroy
      end
        
    end
  
  end
  
  #
  # Log record (simple logger record which holds all the message in)
  #
  class LogRecord
      include DataMapper::Resource

      storage_names[:default] = 'system_log_record'
      
      property :id, Serial, :key => true
      property :thread, String, :field => 'thread', :length => 32
      property :message, Text, :field => 'message'
  
  end



end