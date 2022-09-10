import Foundation
import CoreLocation
import Moya
import GoogleMaps
import PromiseKit

protocol MapViewModelType {
    var currentLocation: CLLocation? { get set }
    var delegate: MapViewModelDelegate? { get set }
    var locationManager: LocationManagerType? { get set }
    var zoomLevel: Float { get set }
    func requestAuthorizationForLocationService()
    func startSearchingNearbyGasStations(quantity: Int)
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        self.delegate?.didUpdateCameraPosition(cameraPosition)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.startUpdatingUserLocation()
    }
}

protocol MapViewModelDelegate: AnyObject {
    func didUpdateCameraPosition(_ cameraPosition: GMSCameraPosition?)
    func didLoadMarkers(_ markers: [GMSMarker])
    func didFailToLoadMarkers(with error: Error)
}

final class MapViewModel: NSObject, MapViewModelType {
    weak var delegate: MapViewModelDelegate?
    var apiProvider: MoyaProvider<PlacesAPI>!
    var currentLocation: CLLocation?
    var zoomLevel: Float = 100.0
    var accuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    var distanceFilter: CLLocationDistance = 30
    
    override init() {
        super.init()
        self.apiProvider = MoyaProvider<PlacesAPI>()
    }
    
    var cameraPosition: GMSCameraPosition? {
        get {
            guard let currentLocation = currentLocation else {
                return nil
            }
            let coordinate = currentLocation.coordinate
            return GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoomLevel)
        }
    }
    
    var locationManager: LocationManagerType? {
        didSet {
            guard var locationManager = locationManager else {
                return
            }
            locationManager.desiredAccuracy = accuracy
            locationManager.distanceFilter = distanceFilter
            locationManager.delegate = self
        }
    }
    
    func requestAuthorizationForLocationService() {
        guard let locationManager = self.locationManager else {
            return
        }
        if type(of: locationManager).authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startUpdatingUserLocation() {
        guard let locationManager = self.locationManager else {
            return
        }
        switch type(of: locationManager).authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func startSearchingNearbyGasStations(quantity: Int) {
        guard let currentLocation = self.currentLocation else {
            return
        }
        apiProvider.request(.searchNearbyGasStations(location: currentLocation.coordinate))
            .compactMap { response in
                return try response.map(SearchResult.self)
            }
            .map { searchResult -> [PlaceViewModel] in
                return searchResult.places?.prefix(quantity).map { PlaceViewModel(model: $0, provider: self.apiProvider) } ?? []
            }
            .done { [weak self] places in
                guard let strongSelf = self else { return }
                let markers = places.map { place -> GMSMarker in
                    let marker = GMSMarker(position: place.location!)
                    marker.userData = place
                    return marker
                }
                strongSelf.delegate?.didLoadMarkers(markers)
            }
            .catch { [weak self] error in
                self?.delegate?.didFailToLoadMarkers(with: error)
            }
    }
    
    deinit {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
}
