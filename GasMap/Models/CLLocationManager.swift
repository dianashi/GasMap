import Foundation
import CoreLocation

protocol LocationManagerType {
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    static func authorizationStatus() -> CLAuthorizationStatus
    func startUpdatingLocation()
    func requestAlwaysAuthorization()
    func stopUpdatingLocation()
}

extension CLLocationManager: LocationManagerType {}
