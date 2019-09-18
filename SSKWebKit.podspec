
Pod::Spec.new do |s|
    s.name         = 'SSKWebKit'
    s.version      = '1.0.0'
    s.summary      = 'SSKWebkit'
    s.homepage     = 'https://github.com/soulCorw/SSKWebKit'
    s.license      = 'Apache-2.0'
    s.authors      = {'SSKWebKit iOS' => 'git@github.com:soulCorw'}
    s.platform     = :ios, '10.0'
    s.source       = {:git => 'git@github.com:soulCorw/SSKWebKit.git', :tag => s.version}



    s.source_files = 'SSKWebKit/SSKWebKit/Sources/*.swift'
    s.resource     = 'SSKWebKit/SSKWebKit/Sources/SSKWebKit.bundle'
    


    s.dependency 'SnapKit', '~> 5.0.0'
    s.dependency 'WebViewJavascriptBridge', '~> 6.0'
    s.dependency 'SwiftyJSON'
    
    
    
    s.swift_version = '5.0'
end
