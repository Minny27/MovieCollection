//
//  Item.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import Foundation

struct Item: Codable {
    let title: String?
    let link: String?
    let image: String?
    let subtitle: String?
    let pubDate: String?
    var director: String?
    var actor: String?
    let userRating: String?
}
