import Foundation
import SwiftUI
import Combine

@MainActor
class GaragesViewModel: ObservableObject {
    @Published var garages: [Garage] = sampleGarages
    @Published var filteredGarages: [Garage] = sampleGarages
    @Published var selectedTab: String = "nearby"
    @Published var searchText: String = "" {
        didSet {
            filterGarages()
        }
    }
    
    func filterGarages() {
        if searchText.isEmpty {
            filteredGarages = garages
        } else {
            filteredGarages = garages.filter { garage in
                garage.name.localizedCaseInsensitiveContains(searchText) ||
                garage.location.localizedCaseInsensitiveContains(searchText) ||
                garage.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply tab-based sorting
        sortByTab()
    }
    
    func sortByTab() {
        switch selectedTab {
        case "nearby":
            filteredGarages.sort { a, b in
                guard let distA = a.distance?.replacingOccurrences(of: " km", with: ""),
                      let distB = b.distance?.replacingOccurrences(of: " km", with: ""),
                      let numA = Double(distA),
                      let numB = Double(distB) else {
                    return false
                }
                return numA < numB
            }
        case "topRated":
            filteredGarages.sort { $0.rating > $1.rating }
        default:
            break
        }
    }
    
    func setTab(_ tab: String) {
        selectedTab = tab
        sortByTab()
    }
}
