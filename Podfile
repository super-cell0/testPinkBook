# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PinkBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PinkBook
  pod 'YPImagePicker'
  pod 'JXSegmentedView'
  pod 'SnapKit', '~> 5.6.0'
  pod 'DZNEmptyDataSet'
  pod 'CombineCocoa'
  pod 'MJRefresh'
  pod 'SwifterSwift'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'Kingfisher', '~> 7.0'
  pod 'CHTCollectionViewWaterfallLayout'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
  installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
           end
      end
    end
end
