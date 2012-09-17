require 'singleton'

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
        log_device.write(message)
      end
    
    end
    
    #
    # Close the devices
    #    
    def close
    
      @log_devices.each do |log_device|
        log_device.close
      end
    
    end
  
  end


end