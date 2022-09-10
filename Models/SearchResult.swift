import Foundation

struct SearchResult: Codable {
    var htmlAttributions: [String]?
    var nextPageToken: String?
    var places: [Place]?
    var status: String?
    enum CodingKeys: String, CodingKey {
        case htmlAttributions = "html_attributions"
        case nextPageToken = "next_page_token"
        case places = "results"
        case status
    }
}
