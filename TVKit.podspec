Pod::Spec.new do |s|
  s.name             = "TVKit"
  s.version          = "0.2.0"
  s.summary          = "UI components for tvOS"

  s.description      = <<-DESC
  Highly customizable.
  Supports @IBDesignable to live-render the component in the Interface Builder.
  By supporting @IBInspectable, the class properties can be exposed in the Interface Builder, and you can edit these properties in realtime.
                       DESC

  s.homepage         = "https://github.com/jinSasaki/TVKit"
  s.screenshots     = "https://raw.githubusercontent.com/jinSasaki/TVKit/master/Assets/slider.png"
  s.license          = 'MIT'
  s.author           = { "Jin Sasaki" => "sasakky.j@gmail.com" }
  s.source           = { :git => "https://github.com/jinSasaki/TVKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sasakky_j'

  s.tvos.deployment_target = '9.2'

  s.source_files = 'Sources/*.swift'
  s.resource_bundles = {
    'TVKit' => ['Sources/*.xib']
  }
  s.frameworks = 'UIKit'
end
