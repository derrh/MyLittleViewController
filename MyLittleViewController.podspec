Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MyLittleViewController"
  s.version      = "0.0.1"
  s.summary      = "Using MVVM to create smaller view controllers."

  s.homepage     = "https://github.com/derrh/MyLittleViewController"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

  s.license      = 'MIT'

  s.author             = { "Derrick Hathaway" => "derr@me.com" }

  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/derrh/MyLittleViewController.git", :commit => "e68c114e875070621d83d2d52fc7f78f4efec7bf" }

  s.source_files  = 'MyLittleViewController', 'MyLittleViewController/**/*.{h,m}'

  s.requires_arc = true

  s.dependency 'ReactiveCocoa'

end
