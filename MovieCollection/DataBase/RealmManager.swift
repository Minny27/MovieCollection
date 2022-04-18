//
//  RealmManager.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/15.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    let realm = try! Realm()
    var movieList = [MovieTableViewCellModel]()
    
    private init() { }
    
    func create(movieInfo: MovieTableViewCellModel) {
        let movie = Movie(movieInfo)
        
        try! realm.write ({
            realm.add(movie)
        })
    }
    
    func read() {
        let list = realm.objects(Movie.self)
        movieList = []
        print(list)
        
        if list.count == 0 {
            return
        }
        
        for movie in list {
            let movieInfo = MovieTableViewCellModel(
                title: movie.title,
                linkString: movie.linkString,
                imageUrlString: movie.imageUrlString,
                director: movie.director,
                actors: movie.actors,
                rating: movie.rating,
                isFavorites: movie.isFavorites
            )
            movieList.append(movieInfo)
        }
    }
    
    func update(movieInfo: MovieTableViewCellModel) {
        if let movie = realm.objects(Movie.self).filter(NSPredicate(format: "title=%@", movieInfo.title ?? "")).first {
            try! realm.write ({
                movie.title = movieInfo.title
                movie.linkString = movieInfo.linkString
                movie.imageUrlString = movieInfo.imageUrlString
                movie.director = movieInfo.director
                movie.actors = movieInfo.actors
                movie.rating = movieInfo.rating
            })
        } else {
            print("해당 영화가 존재하지 않습니다.")
        }
    }
    
    func delete(movieInfo: MovieTableViewCellModel) {
        if let movie = realm.objects(Movie.self).filter(NSPredicate(format: "title=%@", movieInfo.title ?? "")).first {
            try! realm.write({
                realm.delete(movie)
            })
        } else {
            print("해당 영화가 존재하지 않습니다.")
        }
    }
    
    func checkFavorites(movieInfo: MovieTableViewCellModel) -> Bool {
        if let movie = realm.objects(Movie.self).filter(NSPredicate(format: "title=%@", movieInfo.title ?? "")).first {
            return movie.isFavorites
        } else {
            return false
        }
    }
}
