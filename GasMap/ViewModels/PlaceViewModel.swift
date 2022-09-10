import UIKit
import CoreLocation
import Moya
import PromiseKit

struct PlaceViewModel {
    private let place: Place
    var apiProvider: MoyaProvider<PlacesAPI>!
    init(model: Place, provider: MoyaProvider<PlacesAPI>) {
        self.place = model
        self.apiProvider = provider
    }
    init(model: Place) {
        self.init(model: model, provider: MoyaProvider<PlacesAPI>())
    }
    var placeName: String? {
        return place.name
    }
    var placeAddress: String? {
        return place.vicinity
    }
    var placeIcon: String? {
        return place.icon
    }
    var location: CLLocationCoordinate2D? {
        guard
            let latitude = place.geometry?.location?.latitude,
            let longitude = place.geometry?.location?.longitude
        else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
