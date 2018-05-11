import Foundation
import SystemConfiguration.CaptiveNetwork

class ESPTouchNetworkDelegate : NSObject {
    
    func tryOpenNetworkPermission(){
        ESP_NetUtil.tryOpenNetworkPermission()
    }
    func  fetchSsid()->String{
        if let ssidInfo = fetchNetInfo(){
            return ssidInfo.value(forKey: "SSID") as! String
        }
        return "Not Connected to Wifi"
    }
    
    func fetchBssid()->String{
        if let bssidInfo = fetchNetInfo(){
            return bssidInfo.value(forKey: "BSSID") as! String
        }
        return "Not Connected to Wifi"
    }
    
    
    func fetchNetInfo()->NSDictionary?
    {
        let interfaceNames: NSArray = CNCopySupportedInterfaces()!
        
        var SSIDInfo : NSDictionary?
        for interfaceName in interfaceNames {
            if let x =   CNCopyCurrentNetworkInfo(interfaceName as! CFString){
                SSIDInfo = x
            }
        }
        
        return SSIDInfo
    }
}

