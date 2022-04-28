//
//  String.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/14.
//

import Foundation

extension String {
    func encoding() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
