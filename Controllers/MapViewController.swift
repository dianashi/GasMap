import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var resultView: UITextView?
    var searchController: UISearchController? = nil
    var mapViewModel: MapViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewModel = MapViewModel()
        mapViewModel.locationManager = CLLocationManager()
        mapViewModel.delegate = self
        mapViewModel.requestAuthorizationForLocationService()
        setupSearchController()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func setupSearchController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        self.searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for nearby gas stations by location"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .default
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let detailsView = Bundle.main.loadNibNamed("PlaceDetailsView", owner: nil, options: nil)?.first as? PlaceDetailsView,
            let placeViewModel = marker.userData as? PlaceViewModel {
            detailsView.placeName.text = placeViewModel.placeName
            detailsView.placeAddress.text = placeViewModel.placeAddress
            return detailsView
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.mapViewModel.zoomLevel = 14.0
        self.mapViewModel.startSearchingNearbyGasStations(quantity: 10)
    }
}

extension MapViewController: MapViewModelDelegate {
    func didUpdateCameraPosition(_ cameraPosition: GMSCameraPosition?) {
        guard let cameraPosition = cameraPosition else {
            return
        }
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.mapView.animate(to: cameraPosition)
            },
            completion: { [weak self] _ in
                self?.mapView.camera = cameraPosition
            })
    }
    
    func didLoadMarkers(_ markers: [GMSMarker]) {
        searchController?.dismiss(animated: true, completion: nil)
        activityIndicator.stopAnimating()
        mapView.clear()
        markers.forEach { marker in
            marker.appearAnimation = .pop
            marker.map = mapView
        }
    }
    
    func didFailToLoadMarkers(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
      searchController?.isActive = false
      let selectedCoordinate = place.coordinate
      let getLat : CLLocationDegrees = selectedCoordinate.latitude
      let getLon: CLLocationDegrees = selectedCoordinate.longitude
      let selectedCLLocation: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
      mapViewModel.currentLocation = selectedCLLocation
      let marker = GMSMarker()
      marker.position = selectedCoordinate
      let camera = GMSCameraPosition.camera(withLatitude: getLat, longitude: getLon, zoom: 14.0)
      let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
      marker.map = mapView
      self.didUpdateCameraPosition(camera)
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    print("Error: Please try again!")
  }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        mapViewModel.startSearchingNearbyGasStations(quantity: 10)
    }
}
