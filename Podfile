
$minIOSVersion = '15.0'

platform :ios, $minIOSVersion
ensure_bundler!

def common_pods
  pod 'CoordiNode', :git => 'https://github.com/jpeckner/CoordiNode.git', :branch => 'develop'
  pod 'Kingfisher'
  pod 'ReachabilitySwift'
  pod 'SkeletonUI'
  pod 'SnapKit'
  pod 'Shared', :git => 'https://github.com/jpeckner/Shared.git', :branch => 'develop'
  pod 'SwiftDux', :git => 'https://github.com/jpeckner/SwiftDux.git', :branch => 'develop'
end

target 'PlacesFinder' do
  use_frameworks!

  common_pods

  target 'PlacesFinderTests' do
    inherit! :search_paths
    
    common_pods
    
    pod 'CoordiNodeTestComponents', :git => 'https://github.com/jpeckner/CoordiNode.git', :branch => 'develop'
    pod 'Nimble'
    pod 'Quick'
    pod 'SharedTestComponents', :git => 'https://github.com/jpeckner/Shared.git', :branch => 'develop'
    pod 'SwiftDuxTestComponents', :git => 'https://github.com/jpeckner/SwiftDux.git', :branch => 'develop'
  end

  target 'PlacesFinderIntegrationTests' do
    inherit! :search_paths

    common_pods

    pod 'Nimble'
    pod 'Quick'
    pod 'SharedTestComponents', :git => 'https://github.com/jpeckner/Shared.git', :branch => 'develop'
  end

  target 'PlacesFinderUITests' do
    inherit! :search_paths

    common_pods

    pod 'Swifter'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $minIOSVersion
    end
  end
end
