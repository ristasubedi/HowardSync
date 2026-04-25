//
//  MapView.swift
//  howardsync
//
//  Created by Aaryan Panthi on 4/12/26.
//

import SwiftUI
import MapKit

struct CampusMapView: View {
    let buildings: [CampusBuilding]
    
    @State private var searchText = ""
    @State private var selectedBuilding: CampusBuilding?
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.9225, longitude: -77.0197),
            span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
        )
    )
    
    private var filteredBuildings: [CampusBuilding] {
        if searchText.isEmpty {
            return buildings
        }
        return buildings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Campus Map")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search buildings, rooms...", text: $searchText)
                        .font(.system(size: 16))
                }
                .padding(12)
                .background(Color(UIColor.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .background(Color(UIColor.systemBackground))
            
            // Map
            ZStack(alignment: .bottomTrailing) {
                Map(position: $cameraPosition) {
                    ForEach(filteredBuildings) { building in
                        Annotation(building.name, coordinate: building.coordinate) {
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedBuilding = building
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 32, height: 32)
                                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                                    
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(HUTheme.bisonRed)
                                }
                            }
                        }
                    }
                    
                    UserAnnotation()
                }
                .mapStyle(.standard(elevation: .realistic))
                
                // Location button
                Button {
                    // Center on campus
                    withAnimation {
                        cameraPosition = .region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 38.9225, longitude: -77.0197),
                                span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
                            )
                        )
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
                        
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundColor(HUTheme.bisonBlue)
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, selectedBuilding != nil ? 160 : 16)
            }
            
            // Building Detail Sheet
            if let building = selectedBuilding {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(building.name)
                                .font(.system(size: 20, weight: .bold))
                            
                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.system(size: 12))
                                Text(building.address)
                                    .font(HUTheme.captionFont)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedBuilding = nil
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.secondary.opacity(0.5))
                        }
                    }
                    
                    Button {
                        // Open in Apple Maps
                        let placemark = MKPlacemark(coordinate: building.coordinate)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = building.name
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
                    } label: {
                        Text("Get Directions")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(HUTheme.bisonBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(20)
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    CampusMapView(buildings: CampusBuilding.sampleBuildings)
}
