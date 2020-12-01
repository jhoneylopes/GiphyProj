platform :ios, '12.0'

workspace 'GiphyProj.xcworkspace'

plugin 'cocoapods-keys', {
    :project => "GiphyProj",
    :keys => [
        'GiphyAppKey'
    ]
}

def commonPods
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Kingfisher', '~> 5.0'
end

def testPods  
  pod 'RxTest'
end

target 'App' do
  use_frameworks!

  target 'AppTests' do
    inherit! :search_paths
  end
end

target 'uCore' do
  commonPods

  target 'uCoreTests' do
    testPods
  end
end

target 'uFeatures' do
  commonPods
  pod 'RxDataSources', '~> 4.0'
  pod 'SnapKit'
  
  target 'uFeaturesTests' do
    testPods
  end
end
