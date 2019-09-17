
Pod::Spec.new do |s|
    s.name         = 'SSKWebKit'
    s.version      = '1.0.0'
    s.summary      = 'SSKWebkit'
    s.homepage     = 'https://github.com/soulCorw/SSKWebKit'
    s.license      = 'Apache-2.0'
    s.authors      = {'SSKWebKit iOS' => 'git@github.com:soulCorw'}
    s.platform     = :ios, '10.0'
    s.source       = {:git => 'git@github.com:soulCorw/SSKWebKit.git', :tag => s.version}

    s.public_header_files = "Sources/*.h","Sources/Public/*.h"
    s.source_files = 'Sources/**/*.{h,m}'
    s.resource     = 'Sources/HBQRCode.bundle'
    s.requires_arc = true


    s.dependency 'SnapKit', '~> 5.0.0'
end
