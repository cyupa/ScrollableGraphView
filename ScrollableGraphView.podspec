Pod::Spec.new do |s|
s.name             = "ScrollableGraphView"
s.version          = "4.0.4"
s.summary          = "Scrollable graph view for iOS"
s.description      = "An adaptive scrollable graph view for iOS to visualise simple discrete datasets. Written in Swift."
s.homepage         = "https://github.com/wildthink/Scrollable-GraphView"
s.license          = 'MIT'
s.author           = { "wildthink" => "box14@jasonjobe.com" }
# s.source           = { :git => "https://github.com/wildthink/ScrollableGraphView.git", :tag => s.version.to_s }
s.source           = { :git => "https://github.com/wildthink/ScrollableGraphView.git" }
s.platform     = :ios, '8.0'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
s.source_files = 'Classes/**/*.swift'

end
