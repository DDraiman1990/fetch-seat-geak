platform :ios, '14.3'

def appPods
  pod 'R.swift'
  pod 'Hero'
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
