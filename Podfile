source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
ensure_bundler!

def common_pods
  pod 'CoordiNode', :git => 'https://github.com/jpeckner/CoordiNode.git', :branch => 'master'
  pod 'Kingfisher'
  pod 'ReachabilitySwift'
  pod 'SkeletonView'
  pod 'SnapKit'
  pod 'Shared', :git => 'https://github.com/jpeckner/Shared.git', :branch => 'master'
  pod 'SwiftDux', :git => 'https://github.com/jpeckner/SwiftDux.git', :branch => 'master'
end

target 'PlacesFinder' do
  use_frameworks!

  common_pods

  target 'PlacesFinderTests' do
    inherit! :search_paths
    
    common_pods
    
    pod 'CoordiNodeTestComponents', :git => 'https://github.com/jpeckner/CoordiNode.git', :branch => 'master'
    pod 'Nimble'
    pod 'Quick'
    # Note: these need to point to master to workaround podspec limitations
    pod 'SharedTestComponents', :git => 'https://github.com/jpeckner/Shared.git', :branch => 'master'
    pod 'SwiftDuxTestComponents', :git => 'https://github.com/jpeckner/SwiftDux.git', :branch => 'master'
  end

  target 'PlacesFinderIntegrationTests' do
    inherit! :search_paths

    pod 'Nimble'
    pod 'Quick'
    pod 'SharedTestComponents', :git => 'https://github.com/jpeckner/Shared.git', :branch => 'master'
  end

  target 'PlacesFinderUITests' do
    inherit! :search_paths

    pod 'Swifter'
  end

end
