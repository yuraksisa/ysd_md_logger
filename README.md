YSD_MD_LOGGER
=============

<p>Yurak logger is an extension of the ruby loggin system, which defines two new log devices:</p>

<ul>
  <li>Model::LogDevice</li>
  <li>Model::LogDeviceInverseProxy</li>
</ul>

<h2>LogDevice</h2>

<p>It's a log device which stores the log messages in the database.</p>

<pre>
require 'logger'
require 'ysd_md_logger'
logger = ::Logger.new(Model::LogDevice.new)
logger.warn('Warning')
</pre>

<h2>LogDeviceInverseProxy</h2>

<p>It allows to create a inverse proxy of log devices, and can be used when it's necessary to write a log message to some log devices.</p>

<pre>
require 'logger'
require 'ysd_md_logger'
# Register the log devices
::Model::LogDeviceInverseProxy.instance.register_logdevice($stdout)
::Model::LogDeviceInverseProxy.instance.register_logdevice(::Model::LogDevice.new)
# Then create a logger
logger = ::Logger.new(::LogDeviceInverseProxy.instance)
logger.warn('Warning')
</pre>