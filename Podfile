# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Flash Chat' do
  use_frameworks!

pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Kingfisher', '~> 4.0'
pod 'ChameleonFramework'
pod 'SCLAlertView'
pod 'EFInternetIndicator'
 
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
