
Pod::Spec.new do |s|
    s.name         = 'HBQRCode'
    s.version      = '1.0.0'
    s.summary      = 'iOS native two-dimensional code scanning'
    s.homepage     = 'https://gitee.com/LYSoulCorw/HBQRCode'
    s.license      = 'Apache-2.0'
    s.authors      = {'HBToken iOS Team' => 'soulcrow@gitee.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'git@gitee.com:LYSoulCorw/HBQRCode.git', :tag => s.version}

    s.public_header_files = "Sources/*.h","Sources/Public/*.h"
    s.source_files = 'Sources/**/*.{h,m}'
    s.resource     = 'Sources/HBQRCode.bundle'
    s.requires_arc = true


    s.dependency 'SGQRCode', '~> 2.2.0'
end
