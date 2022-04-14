//
//  NetworkError.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

enum NetworkError: Error {
    case invalidUrl
    case invalidStatus
    case invlidResponse
    case decodingError
}
