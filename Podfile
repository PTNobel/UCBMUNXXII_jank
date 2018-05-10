# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UCBMUNXXII' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UCBMUNXXII
  pod 'Firebase/Core'
  #pod 'Firebase'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'PusherSwift'
  pod 'PushNotifications'

  target 'UCBMUNXXIITests' do
    inherit! :search_paths
    
    # Pods for testing
  end

  target 'UCBMUNXXIIUITests' do
    inherit! :search_paths
    # Pods for testing
  end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        plist_buddy = "/usr/libexec/PlistBuddy"
        plist = "Pods/Target Support Files/#{target}/Info.plist"

        puts "Add armv7 to #{target} to make it pass iTC verification."

        `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities array" "#{plist}"`
        `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities:0 string armv7" "#{plist}"`
    end
end
end
