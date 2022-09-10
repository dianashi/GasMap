import Foundation
import Moya
import CoreLocation

enum PlacesAPI {
    case searchNearbyGasStations(location: CLLocationCoordinate2D)
}

extension PlacesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api/place/")!
    }
    var path: String {
        switch self {
        case .searchNearbyGasStations(_):
            return "nearbysearch/json"
        }
    }
    var method: Moya.Method {
        switch self {
        case .searchNearbyGasStations(_):
            return .get
        }
    }
    var task: Task {
        let apiKey = KeyProvider().googleMapsAPIKey
        switch self {
        case .searchNearbyGasStations(let location):
            let parameters = [
                "key": apiKey,
                "location": "\(location.latitude),\(location.longitude)",
                "keyword": "gas-station",
                "type": "gas_station",
                "rankby": "distance"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    var headers: [String : String]? {
        return nil
    }
}

extension PlacesAPI {
    var sampleData: Data {
        switch self {
        case .searchNearbyGasStations(_):
            let sampleDataString = ""
            return sampleDataString.data(using: .utf8)!
        }
    }
}
