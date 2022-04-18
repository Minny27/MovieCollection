//
//  Movie.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/15.
//

import Foundation
import RealmSwift

class Movie: Object {
    @objc dynamic var title: String?
    @objc dynamic var linkString: String?
    @objc dynamic var imageUrlString: String?
    @objc dynamic var director: String?
    @objc dynamic var actors: String?
    @objc dynamic var rating: String?
    @objc dynamic var isFavorites = false
    
    convenience init(_ movieInfo: MovieTableViewCellModel) {
        self.init()
        title = movieInfo.title
        linkString = movieInfo.linkString
        imageUrlString = movieInfo.imageUrlString
        director = movieInfo.director
        actors = movieInfo.actors
        rating = movieInfo.rating
        isFavorites = movieInfo.isFavorites
    }
}
