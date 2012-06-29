require 'singleton'
require 'logger' 
require 'monitor'

module Model

  #
  # Logger inverse proxy allows create an inverse proxy of loggers
  #
  # stdout_logger = ::Logger.new($stdout)
  # file_logger   = ::Logger.new('./log.log')
  #
  # Model::LoggerInverseProxy.register_logger(stdout_logger)
  # Model::LoggerInverseProxy.register_logger(file_logger)
  #
  # Assign the Model::LoggerInverseProxy
  #
  #
  class LoggerInverseProxy
    include Singleton
    
    attr_reader :loggers
   
    def initialize
      @loggers = []
    end
   
    def register_logger(logger)
      @loggers << logger
    end
   
    def debug(progname=nil, &block)
    
      loggers.each do |logger|
        logger.debug(progname, &block)
      end
    
    end
    
    def info(progname=nil, &block)

      loggers.each do |logger|
        logger.info(progname, &block)
      end
    
    end
    
    def warn(progname=nil, &block)

      loggers.each do |logger|
        logger.warn(progname, &block)
      end
    
    end
    
    def error(progname=nil, &block)

      loggers.each do |logger|
        logger.error(progname, &block)
      end
    
    end
    
    def fatal(progname=nil, &block)

      loggers.each do |logger|
        logger.fatal(progname, &block)
      end
    
    end
  end #Logger
  
  #
  # It represents a logger 
  #
  class YSDLogger < Logger
  
    class YSDLoggerMutex
       include MonitorMixin
    end   
  
    #
    # Constructor
    #
    def initialize(opts={})
    
       @mutex = YSDLoggerMutex.new
       @level = opts[:level] || ERROR
       @max_size = opts[:max_size] || 2000 
       @progname = opts[:progname]
       
    end
    
    #
    # Add a log message
    #
    def add(severity, message=nil, progname=nil, &block)
      
      if severity < @level
        return true
      end
       
      progname = progname || @progname 
      
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end
       
      @mutex.synchronize do
         check_shift_log
         begin
           LogMessage.create({:date_time => Time.now, 
                            :severity => format_severity(severity), 
                            :thread => Thread.current.inspect.match(/:(\w+)/)[1],
                            :progname => progname, 
                            :message_summary => message.slice(0,255), 
                            :message => message})
      
         rescue 
           puts("Error creating message #{$!}")
         end
      end
        
      true
    
    end
  
    private
    
    SEVERITIES_LABELS = %w(DEBUG INFO WARN ERROR FATAL ANY)
    
    def format_severity(severity)
      SEVERITIES_LABELS[severity] || 'ANY'    
    end
    
    def check_shift_log
      
      if LogMessage.count == @shift_size 
        LogMessage.all({:order => [:id.asc], :limit =>1}).destroy
      end
        
    end
  
  end
      
  #
  # Log message
  #
  class LogMessage
     include DataMapper::Resource
      
      storage_names[:default] = 'system_log'
      
      property :id, Serial, :key => true
      property :date_time, DateTime, :field => 'date_time'
      property :progname, String, :field => 'progname', :length => 256
      property :thread, String, :field => 'thread', :length => 32
      property :severity, String, :field => 'severity', :length => 5
      property :message_summary, String, :field => 'message_summary', :length => 256
      property :message, Text, :field => 'message'
        
  end  
  
end