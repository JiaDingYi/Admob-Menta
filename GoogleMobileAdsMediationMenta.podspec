Pod::Spec.new do |s|
  s.name             = 'GoogleMobileAdsMediationMenta'
  s.version          = '0.1.0'
  s.summary          = 'Menta'
  s.description      = 'Menta with Admob'
  s.homepage         = 'https://github.com/jdy/AdmobDemo'
  s.license          = 'Custom'
  s.author           = { 'zy' => 'wzy2010416033@163.com' }
  
  s.source           = { :git => 'https://github.com/jdy/AdmobDemo.git', :tag => s.version.to_s }
  s.static_framework = true
  s.ios.deployment_target = '12.0'

  s.source_files = 'AdmobDemo/Classes/**/*'
  
  s.dependency 'MentaVlionGlobal', '1.0.0'
  s.dependency 'MentaMediationGlobal', '1.0.0'
  s.dependency 'MentaVlionGlobalAdapter', '1.0.0'
  s.dependency 'Google-Mobile-Ads-SDK'
  
end
