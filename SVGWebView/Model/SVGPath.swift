//
//  SVGPath.swift
//  SVGWebView
//
//  Created by Trương Văn Kiên on 03/03/2021.
//

import UIKit

struct SVGPath {
    
    var id: String
    var rect: CGRect
    var originalRect: CGRect
    
    init?(with data: [String: Any]) {
        guard let id = data["id"] as? String,
              let x = data["x"] as? CGFloat,
              let y = data["y"] as? CGFloat,
              let width = data["width"] as? CGFloat,
              let height = data["height"] as? CGFloat else {
            return nil
        }
        let rect = CGRect(x: x, y: y, width: width, height: height)
        self.id = id
        self.rect = rect
        self.originalRect = rect
    }
}

extension SVGPath {
    
    static func from(string: String) -> [SVGPath] {
        guard let data = string.data(using: .utf8) else { return [] }
        guard let datas = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return [] }
        var seats = [SVGPath]()
        for data in datas {
            guard let path = SVGPath(with: data) else { continue }
            seats.append(path)
        }
        return seats
    }
}
