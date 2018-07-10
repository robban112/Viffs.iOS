# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Blipp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Blipp
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'

  pod 'RxSwift',  '~> 4.0'
  pod 'RxCocoa',  '~> 4.0'
  pod 'Overture', '~> 0.2'
  pod 'Result', '~> 4.0.0'
  pod 'RxDataSources', '~> 3.0'

  target 'BlippTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
  end

  target 'BlippFramework' do
    inherit! :search_paths
    # Pods for framework
  end

  target 'BlippFrameworkTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
  end

end