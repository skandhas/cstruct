Gem::Specification.new do |s|
  s.name     = 'cstruct'
  s.version  = '1.0.1.pre'
  s.author   = ['skandhas']
  s.email    = 'skandhas@163.com'
  s.homepage = "http://github.com/skandhas/cstruct"
  s.summary  = "CStruct is a simulation of the C language's struct."
  s.files    = Dir['{lib/**/*,spec/**/*,examples/**/*,doc/**/*}'] +
                  %w(README.md cstruct.gemspec)                
end
