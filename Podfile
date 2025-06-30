# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EvaConnect' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for EvaConnect
  #pod 'netfox'
  #pod 'IQKeyboardManagerSwift'
  #pod 'ReachabilitySwift'
  pod 'Alamofire', '~> 4.9.0'
  #pod 'IHProgressHUD'
  #pod 'SwiftyJSON', '~> 4.0'
  #pod 'ValidationTextField'
  #pod 'SDWebImage/MapKit'
  pod 'URLEmbeddedView'
  pod 'ImageSlideshow/SDWebImage'
  #pod 'Kingfisher', '~> 5.0'
  #pod 'LabelSwitch'
  
#  pod 'GooglePlaces'
 pod 'GoogleAPIClientForREST/Calendar'
 pod 'GoogleSignIn', '~> 5.0'
#
 # pod 'Firebase/Core'
 # pod 'Firebase/Auth'
 # pod 'Firebase/Database'
 # pod 'Firebase/Messaging'

 # pod 'FBSDKLoginKit', '~> 5.15.1'
 # pod 'FBSDKCoreKit', '~> 5.0'

#  pod 'Fabric'
 # pod 'FirebaseCrashlytics'
  #pod 'FSCalendar'
 # pod 'OneSignal', '>= 2.11.2', '< 3.0'
  end

 # target 'OneSignalNotificationServiceExtension' do
  #  use_frameworks!
   # pod 'OneSignal', '>= 2.11.2', '< 3.0'
  # end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
