//
//  MovieTableViewModel.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import Foundation

final class MovieTableViewModel {
    let realmManager = RealmManager.shared
    var movieList: Observable<[MovieTableViewCellModel]> = Observable([])
    
    func fetchMovieData() {
        NetworkManager().getMovieData { receivedMovieModel in
            self.movieList.value = receivedMovieModel?.items?.compactMap { item in
                var item = item
                if !(item.director?.isEmpty ?? true) { item.director?.removeLast() }
                if !(item.actor?.isEmpty ?? true) { item.actor?.removeLast() }
                
                var movieInfo = MovieTableViewCellModel(
                    title: item.title?.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: ""),
                    linkString: item.link,
                    imageUrlString: item.image,
                    director: item.director?.replacingOccurrences(of: "|", with: ", "),
                    actors: item.actor?.replacingOccurrences(of: "|", with: ", "),
                    rating: item.userRating
                )
                movieInfo.isFavorites = self.realmManager.checkFavorites(movieInfo: movieInfo)
                return movieInfo
            }
        }
    }
}
