//
//  Extensions.swift
//  Tik_Saver_pro
//
//  Created by Anil Jadav on 08/01/26.
//
import SwiftUI

struct AppFont {
    static let Poppins_SemiBold = "Poppins-SemiBold"
    static let Poppins_Regular = "Poppins-Regular"
    static let Poppins_Medium = "Poppins-Medium"
    
}

struct AppColor {
    static let Cyan = Color(red: 2.0/255.0, green: 241.0/255.0, blue: 233.0/255.0)
    static let Gray = Color(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0)
    static let Pink = Color(red: 254.0/255.0, green: 45.0/255.0, blue: 86.0/255.0)
}

extension Encodable {
    func prettyPrintedJSON(unescapedSlashes: Bool = true) -> String {
        guard
            let data = try? JSONEncoder().encode(self),
            let object = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .sortedKeys]
            ),
            var json = String(data: prettyData, encoding: .utf8)
        else {
            return "❌ Failed to print JSON"
        }

        if unescapedSlashes {
            json = json.replacingOccurrences(of: "\\/", with: "/")
        }

        return json
    }
}
