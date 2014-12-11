Pod::Spec.new do |s|
  s.name         = "URLGrey"
  s.version      = "0.1.0"
  s.summary      = "Delightful I/O and file management in Swift."
  s.description  = "Delightful I/O and file management in Swift, building on Cocoa paradigms and Swift idioms to encourage modern practices for files."
  s.homepage     = "https://github.com/zwaldowski/URLGrey"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Zachary Waldowski" => "zach@waldowski.me" }
  s.social_media_url = "http://twitter.com/zwaldowski"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source       = { :git => "https://github.com/zwaldowski/URLGrey", :tag => "v#{s.version}" }
  s.source_files  = "URLGrey/*.swift"
  s.exclude_files = "Classes/Exclude"
  s.dependency "LlamaKit", "~> 0.1.0"
end