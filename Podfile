platform :ios, '14.3'

target 'fetch-seat-geek' do
  use_frameworks!

  pod 'R.swift'
  pod 'Hero'

  
  abstract_target 'Tests' do
    inherit! :search_paths
    target "fetch-seat-geekTests"
    target "fetch-seat-geekUITests"

    pod 'Quick'
    pod 'Nimble'
  end

end
