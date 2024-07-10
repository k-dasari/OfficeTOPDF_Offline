

Pod::Spec.new do |spec|

  spec.name         = "OfficeTOPDF_Offline"
  spec.version      = "0.0.1"
  spec.summary      = "Office files to PDF conversion"
  spec.license      = { :type => 'MIT'} 
  spec.description  = <<-DESC
  					This repository will try to convert MSOffice files such as word, Ppt and excel to PDF format.
                   DESC
  spec.homepage     = "https://github.com/k-dasari/OfficeTOPDF_Offline"
  spec.author             = { "Karthik Dasari" => "kdasari@opentext.com" }
  spec.source       = { :git => "https://github.com/k-dasari/OfficeTOPDF_Offline.git", :tag => "0.0.1" }
  spec.source_files  = "ios/Mobile/*.*"
  spec.exclude_files = "Classes/Exclude"
  spec.resources = "ios/Mobile/Resources/*.*"
  spec.library   = "iconv"
  spec.libraries = "iconv", "xml2"
  spec.requires_arc = true
  spec.platform     = :ios, '14.0'
  spec.osx.deployment_target = '10.13'
  spec.tvos.deployment_target = '12.0'
  #spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.dependency "JSONKit", "~> 1.4"
  spec.xcconfig = { 
      'HEADER_SEARCH_PATHS' => '$(inherited) ${PODS_ROOT}/Headers/Public ${PODS_ROOT}/Headers/Private' 
    }

end
