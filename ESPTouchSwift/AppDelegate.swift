import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var espTouchNetworkDelegate = ESPTouchNetworkDelegate()
    private var reachability:Reachability!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        espTouchNetworkDelegate.tryOpenNetworkPermission()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let vc = self.window?.rootViewController as? ViewController{
            vc.ssidInputText.text = espTouchNetworkDelegate.fetchSsid()
            vc.bssid = espTouchNetworkDelegate.fetchBssid()
        }
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .flagsChanged, object: Network.reachability)
    }
    
    @objc func reachabilityChanged(notification:Notification) {
        let reachability = notification.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

