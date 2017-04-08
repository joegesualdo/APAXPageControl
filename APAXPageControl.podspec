Pod::Spec.new do |s|
  s.name             = 'APAXPageControl'
  s.version          = '0.1.1'
  s.summary          = 'An easy to implement iOS page control'
 
  s.description      = <<-DESC
An easy to implement iOS page control.
                       DESC
 
  s.homepage         = 'https://github.com/joegesualdo/APAXPageControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Joe Gesualdo' => 'joegesualdo@gmail.com' }
  s.source           = { :git => 'https://github.com/joegesualdo/APAXPageControl.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'APAXPageControl/APAXPageControlController.swift'
end
