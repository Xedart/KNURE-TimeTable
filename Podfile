
platform :ios, '9.0'
use_frameworks!

target 'KNURE TimeTable' do

pod 'AsyncDisplayKit'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'ChameleonFramework/Swift'
pod 'SVProgressHUD'
pod 'RESideMenu', '~> 4.0.7'
pod 'FZAccordionTableView', '~> 0.1.3'

end

target 'KNURE TimeTableTests' do

end

post_install do |installer|
app_plist = "/Users/shkilartur/Desktop/IOS_Projects/KNURE\ TimeTable/KNURE\ TimeTable/Info.plist"
plist_buddy = "/usr/libexec/PlistBuddy"

version = `#{plist_buddy} -c "Print CFBundleShortVersionString" "#{app_plist}"`.strip

puts "Updating CocoaPods frameworks' version numbers to #{version}"

installer.pods_project.targets.each do |target|
`#{plist_buddy} -c "Set CFBundleShortVersionString #{version}" "Pods/Target Support Files/#{target}/Info.plist"`
end
end

