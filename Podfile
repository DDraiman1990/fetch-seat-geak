platform :ios, '12.0'

def appPods
  pod 'R.swift'
  pod 'Hero'
  pod 'Nuke', '~> 9.0'
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
end

def testPods
  pod 'Quick'
  pod 'Nimble'
end

target 'fetch-seat-geek' do
  use_frameworks!

  appPods

  target 'fetch-seat-geekTests' do
    inherit! :search_paths
    testPods
  end
  
  target 'fetch-seat-geekUITests' do
    inherit! :search_paths
    testPods
  end
end
