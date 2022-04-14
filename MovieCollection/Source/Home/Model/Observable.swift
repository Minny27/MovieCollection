//
//  Observable.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import Foundation

final class Observable<T> {
    private var listener: ((T?) -> Void)?
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping ((T?) -> Void)) {
        listener(value)
        self.listener = listener
    }
}
