Pod::Spec.new do |s|
  s.name             = 'NGTools'
  s.version          = '0.1.1'
  s.summary          = 'Tools used by Nuglif\'s ios team'

  s.description      = <<-DESC
This a collection of our differents helpers functions which does not belongs to any particular module or project and are used among these projects and modules.
                       DESC

  s.homepage         = 'https://github.com/nuglif/ngtools'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Team Nuglif' => 'awerck@nuglif.com' }
  s.source           = { :git => 'https://github.com/nuglif/ngtools.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.2'
  s.swift_version = '4.2'
  s.source_files = 'NGTools/NGTools/**/*.{swift}'

end
