#
#  Be sure to run `pod spec lint LvMarqueeView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name         = "LvMarqueeView"
s.version      = "0.0.1"
s.summary      = "跑马灯 无限轮播"
s.description  = "跑马灯 无限轮播。"
s.homepage     = "https://github.com/PlacidoLv/LvMarqueeView"
s.license      = "MIT"
s.author       = { "PlacidoLv" => "327853338@qq.com" }
s.platform     = :ios
s.source       = { :git => "https://github.com/PlacidoLv/LvMarqueeView.git", :tag => "0.0.1",:commit => "91c27a1ab40a9e00ff9fb52bd682ab06de01b4f7" }
s.source_files  = "LvMarqueeView/*"

s.requires_arc = true
s.dependency  'SDWebImage'
end
