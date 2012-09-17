module Model
  #
  # It represents a log device which create LogRecord (logs messages in the database)
  #
  class LogDevice
    
    def initialize(opts={})
      @max_size = opts[:max_size] || 2000
    end
    
    #
    # Write a message
    #
    def write(message)

       check_shift_log
       begin
          LogRecord.create({:thread => Thread.current.inspect.match(/:(\w+)/)[1],
                            :message => message})
      
       rescue 
          puts("Error creating message #{$!}")
       end
      
    end
    
    #
    # Close the devices
    #
    def close
      # Does not nothing (the database manages it)
    end
  
    private
    
    def check_shift_log
      
      if LogRecord.count == @max_size 
        LogRecord.all({:order => [:id.asc], :limit =>1}).destroy
      end
        
    end
  
  end
  
end