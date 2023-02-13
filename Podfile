
platform :ios, '15.0'
ensure_bundler!

def common_pods
  pod 'CoordiNode', :git => 'https://github.com/jpeckner/CoordiNode.git', :branch => 'develop'
  pod 'Kingfisher'
  pod 'ReachabilitySwift'
  pod 'SkeletonView'
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
