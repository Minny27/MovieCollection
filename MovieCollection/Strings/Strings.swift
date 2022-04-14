//
//  Strings.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

enum Strings {
    static let baseUrl = "https://openapi.naver.com/v1/search/movie.json?query="
    static let keyword =  "국가".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    static let movieCount = "&display=20"
    static let urlString = "\(Strings.baseUrl)\(Strings.keyword)\(Strings.movieCount)"
    static let apiKey = "zSNFHRyW116cmqwwuLRJ"
    static let password = "1PxJnc3C0L"
}
