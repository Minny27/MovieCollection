//
//  Strings.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

enum Strings {
    static let apiKey = "zSNFHRyW116cmqwwuLRJ"
    static let password = "1PxJnc3C0L"
    static let baseUrl = "https://openapi.naver.com/v1/search/movie.json?query="
    static let movieCount = "&display=100"
    static var keyword =  "국가"
    
    static var urlString: String {
        return (Strings.baseUrl + Strings.keyword + Strings.movieCount).encoding() ?? ""
    }
}
