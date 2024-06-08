//
//  SearchManager.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-09.
//

import SwiftUI
import MapKit
import CoreLocation

class SearchManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    var searchCompleter: MKLocalSearchCompleter

    override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        super.init()
        self.searchCompleter.delegate = self
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    func search(with query: String) {
        self.searchCompleter.queryFragment = query
    }
}
