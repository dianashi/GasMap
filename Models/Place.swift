import Foundation

struct Geometry: Codable {
    struct Location: Codable {
        var latitude: Double?
        var longitude: Double?
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
    struct ViewPort: Codable {
        var northeast: Location?
        var southwest: Location?
    }
    var location: Location?
    var viewport: ViewPort?
}

struct PlusCode: Codable {
    var compound: String?
    var global: String?
    enum CodingKeys: String, CodingKey {
        case compound = "compound_code"
        case global = "global_code"
    }
}

struct OpeningHours: Codable {
    var openNow: Bool?
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Place: Codable {
    var id: String?
    var name: String?
    var placeId: String?
    var icon: String?
    var reference: String?
    var scope: String?
    var types: [String]?
    var vicinity: String?
    var geometry: Geometry?
    var plusCode: PlusCode?
    var openingHours: OpeningHours?
    var rating: Double?
    var priceLevel: Double?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case placeId = "place_id"
        case icon
        case reference
        case scope
        case types
        case vicinity
        case geometry
        case plusCode = "plus_code"
        case openingHours = "opening_hours"
        case rating
    }
}
