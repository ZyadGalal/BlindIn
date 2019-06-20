# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BlindIn' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BlindIn
    pod 'MOLH'
    pod 'FTIndicator'
    pod 'IQKeyboardManagerSwift'
    pod 'GoogleMaps'
    pod 'TextFieldEffects'
    pod 'Floaty', '~> 4.2.0'
    pod 'lottie-ios','~> 3.0.7'
    pod 'ObjectiveDDP'
    pod 'AWSS3'

    post_install do |installer|
installer.pods_project.build_configurations.each do |config|
config.build_settings.delete('CODE_SIGNING_ALLOWED')
config.build_settings.delete('CODE_SIGNING_REQUIRED')
end
end

  target 'BlindInTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BlindInUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
