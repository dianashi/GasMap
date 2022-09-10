import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let keyProvider = KeyProvider()
        GMSPlacesClient.provideAPIKey(keyProvider.googleMapsAPIKey)
        GMSServices.provideAPIKey(keyProvider.googleMapsAPIKey)
        return true
    }
}
