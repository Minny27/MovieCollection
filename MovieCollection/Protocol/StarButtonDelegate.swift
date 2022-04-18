//
//  StarButtonDelegate.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/16.
//

protocol StarButtonDelegate: AnyObject {
    func updateDataBase(_ movieInfo: MovieTableViewCellModel, _ isClicked: ButtonStatus)
}
