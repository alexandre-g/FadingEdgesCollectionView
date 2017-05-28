Pod::Spec.new do |s|
  s.name             = 'FadingEdgesCollectionView'
  s.version          = '0.1'
  s.summary          = 'A UICollectionView that fades its edges to hint about more content'
 
  s.description      = <<-DESC
A UICollectionView that fades its edges to hint about more content
                       DESC
 
  s.homepage         = 'https://github.com/alexandre-g/FadingEdgesCollectionView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexandre Goloskok' => 'alexandre@goloskok.com' }
  s.source           = { :git => 'https://github.com/alexandre-g/FadingEdgesCollectionView.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '8.0'
  s.dependency 'HTGradientEasing-Fixed'
  s.source_files = 'FadingEdgesCollectionView/Lib/*.swift'

end