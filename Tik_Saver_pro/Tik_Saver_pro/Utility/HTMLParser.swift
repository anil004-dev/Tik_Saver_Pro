//
//  HTMLParser.swift
//  TikSavePro
//
//  Created by Bhautik Patoliya on 06/01/26.
//


import Foundation

enum HTMLParser {

    static func extractUniversalJSON(from html: String) throws -> Data {
        let pattern =
        #"<script id="__UNIVERSAL_DATA_FOR_REHYDRATION__" type="application/json">(.*?)</script>"#

        let regex = try NSRegularExpression(
            pattern: pattern,
            options: [.dotMatchesLineSeparators]
        )

        let range = NSRange(html.startIndex..., in: html)

        guard let match = regex.firstMatch(in: html, range: range),
              let jsonRange = Range(match.range(at: 1), in: html) else {
            throw NSError(domain: "JSON_NOT_FOUND", code: -1)
        }

        return Data(html[jsonRange].utf8)
    }
}
