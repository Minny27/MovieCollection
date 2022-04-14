//
//  NetworkManager.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import Alamofire

class NetworkManager {
    func getMovieData(completion: @escaping (ReceivedMovieModel?) -> Void) {
        let urlString = Strings.urlString
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "\(Strings.apiKey)",
            "X-Naver-Client-Secret": "\(Strings.password)"
        ]
        
        AF.request(urlString, headers: headers).responseString { response in
            if response.response?.url == nil {
                print(NetworkError.invalidUrl)
                return
            }
                        
            guard let statusCode = response.response?.statusCode, (200...299).contains(statusCode) else {
                print(NetworkError.invalidStatus)
                return
            }
                        
            guard let data = response.data, response.error == nil else {
                print(NetworkError.invlidResponse)
                return
            }
            
            var movieList: ReceivedMovieModel?
            
            do {
                let decoder = JSONDecoder()
                movieList = try decoder.decode(ReceivedMovieModel.self, from: data)
                completion(movieList)
            } catch {
                print(NetworkError.decodingError)
            }
        }
    }
}
