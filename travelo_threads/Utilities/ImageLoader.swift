//
//  ImageLoader.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = true

    private var cancellable: AnyCancellable?

    func load(url: URL, forceReload: Bool = false) {
        var finalURL = url
        if forceReload {
            finalURL = url.appendingQueryItem(name: "cache_bust", value: "\(UUID().uuidString)")
        }

        let cache = URLCache.shared

        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: finalURL)) {
            self.image = UIImage(data: cachedResponse.data)
            self.isLoading = false
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: finalURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                if let data = image?.jpegData(compressionQuality: 1.0) {
                    let response = URLResponse(url: finalURL, mimeType: "image/jpeg", expectedContentLength: data.count, textEncodingName: nil)
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedResponse, for: URLRequest(url: finalURL))
                }
                self?.isLoading = false
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

extension URL {
    func appendingQueryItem(name: String, value: String) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return self }
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? self
    }
}
