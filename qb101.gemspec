Gem::Specification.new do |s|
  s.name = 'qb101'
  s.version = '0.2.0'
  s.summary = 'Makes it convenient to create a questions and answers book. ' + 
      'To be used in conjunction with the ChatGpt2023 gem.'
  s.authors = ['James Robertson']
  s.files = Dir["lib/qb101.rb", "data/qb101.txt"]
  s.add_runtime_dependency('yatoc', '~> 0.3', '>=0.3.5')
  s.add_runtime_dependency('kramdown', '~> 2.4', '>=2.4.0')
  s.signing_key = '../privatekeys/qb101.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/qb101'
end
