//
//  HTTPClient.swift
//  TikSavePro
//
//  Created by Bhautik Patoliya on 06/01/26.
//

import Foundation
import UIKit

final class HTTPClient {

    static let shared = HTTPClient()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
            "Accept": "text/html,application/xhtml+xml",
            "Accept-Language": "en-US,en;q=0.9"
        ]
        return URLSession(configuration: config)
    }()

    func get(_ url: URL) async throws -> String {
        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return String(decoding: data, as: UTF8.self)
    }
}
