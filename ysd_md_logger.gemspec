Gem::Specification.new do |s|
  s.name    = "ysd_md_logger"
  s.version = "0.2.0"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-06-21"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb']
  s.summary = "Logger model"
  s.homepage = "http://github.com/yuraksisa/ysd_md_logger"
  
  s.add_runtime_dependency "data_mapper", "1.2.0"

  s.add_runtime_dependency "ysd_md_configuration"
    
end