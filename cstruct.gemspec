Gem::Specification.new do |s|
  s.name    = 'cstruct'
  s.version = '1.1.0'
  s.author  = 'skandhas'
  s.email   = 'skandhas@163.com'
  s.summary = "CStruct is a simulation of the C language's struct."

  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'blankslate', '>= 2.1.2.4'

  s.files = Dir["#{File.dirname(__FILE__)}/**/*"]
end
