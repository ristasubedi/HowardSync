//
//  CampusBuilding.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import Foundation
import CoreLocation

struct CampusBuilding: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let category: BuildingCategory
    
    static let sampleBuildings: [CampusBuilding] = [
        CampusBuilding(
            name: "Engineering Building",
            address: "2300 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9228, longitude: -77.0194),
            category: .academic
        ),
        CampusBuilding(
            name: "Founders Library",
            address: "2400 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9220, longitude: -77.0189),
            category: .academic
        ),
        CampusBuilding(
            name: "Blackburn University Center",
            address: "2397 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9225, longitude: -77.0200),
            category: .dining
        ),
        CampusBuilding(
            name: "Burr Gymnasium",
            address: "2455 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9232, longitude: -77.0210),
            category: .athletics
        ),
        CampusBuilding(
            name: "Locke Hall",
            address: "2441 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9223, longitude: -77.0195),
            category: .academic
        ),
        CampusBuilding(
            name: "Cramton Auditorium",
            address: "2455 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9218, longitude: -77.0202),
            category: .other
        ),
        CampusBuilding(
            name: "School of Business",
            address: "2600 Sixth Street NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9235, longitude: -77.0185),
            category: .academic
        ),
        CampusBuilding(
            name: "Bethune Annex",
            address: "2225 Georgia Ave NW, Washington, DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.9215, longitude: -77.0208),
            category: .dining
        )
    ]
}

enum BuildingCategory: String, CaseIterable {
    case academic = "Academic"
    case dining = "Dining"
    case athletics = "Athletics"
    case residential = "Residential"
    case other = "Other"
}
