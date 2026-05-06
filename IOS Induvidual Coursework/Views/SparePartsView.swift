import SwiftUI

struct SparePartsView: View {
    @State private var sparePartsData: [SparePart] = spareParts
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "ALL PARTS"
    
    var filteredParts: [String: [SparePart]] {
        let filtered = sparePartsData.filter { part in
            matchesSelectedCategory(part) && matchesSearchText(part)
        }
        
        var grouped: [String: [SparePart]] = [:]
        for part in filtered {
            grouped[part.category, default: []].append(part)
        }
        return grouped
    }

    private func matchesSelectedCategory(_ part: SparePart) -> Bool {
        guard selectedCategory != "ALL PARTS" else { return true }

        let category = selectedCategory.replacingOccurrences(of: " ", with: "")
        let normalizedPartCategory = part.category.replacingOccurrences(of: " ", with: "")

        switch category {
        case "ENGINE":
            return normalizedPartCategory.localizedCaseInsensitiveContains("engine")
        case "BRAKES":
            return normalizedPartCategory.localizedCaseInsensitiveContains("brake")
        case "FILTERS":
            return normalizedPartCategory.localizedCaseInsensitiveContains("filter")
        case "ELECTRICAL":
            return normalizedPartCategory.localizedCaseInsensitiveContains("electrical") || normalizedPartCategory.localizedCaseInsensitiveContains("battery")
        default:
            return true
        }
    }

    private func matchesSearchText(_ part: SparePart) -> Bool {
        guard !searchText.isEmpty else { return true }

        return part.name.localizedCaseInsensitiveContains(searchText) ||
        part.compatibility.localizedCaseInsensitiveContains(searchText)
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("RepairCost LK")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if isLoading {
                            ProgressView("Loading spare parts...")
                                .padding(.horizontal, 20)
                        }

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                        }

                        // MARK: - Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("INVENTORY")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                            
                            Text("Spare Parts")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        // MARK: - Search Bar
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            TextField("Search brake pads, filters...", text: $searchText)
                                .font(.system(size: 14))
                                .tint(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        
                        // MARK: - Category Buttons
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(partCategories, id: \.self) { category in
                                    Button(action: { selectedCategory = category }) {
                                        Text(category)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(selectedCategory == category ? .white : .black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == category ? Color.black : Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)))
                                            .cornerRadius(6)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // MARK: - Parts List
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach(filteredParts.sorted(by: { $0.key < $1.key }), id: \.key) { category, parts in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(category)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Button(action: {}) {
                                            Image(systemName: "info.circle")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    VStack(spacing: 12) {
                                        ForEach(parts) { part in
                                            SparePartItemView(part: part)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // MARK: - Disclaimer
                        VStack(alignment: .leading, spacing: 6) {
                            Text("* Prices are estimated based on latest market average.")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.gray)
                            
                            Text("Market volatility may apply")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - Trending Comparisons
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TRENDING COMPARISONS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                            
                            VStack(spacing: 12) {
                                ForEach(trendingComparisons) { comparison in
                                    TrendingComparisonItemView(comparison: comparison)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
                .safeAreaPadding(.bottom, TabBarLayout.bottomClearance)
            }
            .task {
                await loadSpareParts()
            }
        }
    }

    private func loadSpareParts() async {
        isLoading = true
        errorMessage = nil

        do {
            let parts = try await SupabaseService.shared.fetchSpareParts()
            await MainActor.run {
                sparePartsData = parts.isEmpty ? spareParts : parts
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                sparePartsData = spareParts
                isLoading = false
            }
        }
    }
}

// MARK: - Spare Part Item View
struct SparePartItemView: View {
    let part: SparePart
    
    var body: some View {
        HStack(spacing: 12) {
            // Image
            if let imageURLString = part.imageURL,
               !imageURLString.isEmpty,
               let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.2)
                            ProgressView()
                                .tint(.orange)
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .font(.system(size: 16))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    @unknown default:
                        ZStack {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    }
                }
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "wrench.and.screwdriver")
                        .font(.system(size: 16))
                        .foregroundColor(.gray.opacity(0.5))
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(part.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(part.compatibility)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                if let supplier = part.supplier {
                    Text(supplier)
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Rs. \(Int(part.price)):00")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
    }
}

// MARK: - Trending Comparison Item View
struct TrendingComparisonItemView: View {
    let comparison: PartComparison
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: comparison.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(comparison.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(comparison.category)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(comparison.range)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                
                Button(action: {}) {
                    Text("VIEW")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.init(UIColor(red: 0.8, green: 0.4, blue: 0, alpha: 1)))
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    SparePartsView()
}
