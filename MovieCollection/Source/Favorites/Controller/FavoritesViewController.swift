//
//  FavoritesViewController.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/16.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Properties
    let realmManager = RealmManager.shared
    
    let favoritesTableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(
            self,
            action: #selector(refreshFavorites),
            for: .valueChanged
        )
        return rf
    }()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupMovieTableView()
    }
    
    func setupNavigationController() {
        navigationItem.title = "즐겨찾기 목록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(clickXmark)
        )
    }
    
    func setupMovieTableView() {
        view.addSubview(favoritesTableView)
        favoritesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        favoritesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        favoritesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        favoritesTableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
        
        realmManager.read()
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        
        favoritesTableView.refreshControl = refreshControl
    }
    
    @objc func clickXmark() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshFavorites() {
        realmManager.read()
        favoritesTableView.reloadData()
    }
}

// MARK: - StarButtonDelegate
extension FavoritesViewController: StarButtonDelegate {
    func updateDataBase(_ movieInfo: MovieTableViewCellModel, _ isClicked: ButtonStatus) {
        switch isClicked {
        case .off:
            realmManager.delete(movieInfo: movieInfo)
        case .on:
            realmManager.create(movieInfo: movieInfo)
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmManager.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as! MovieTableViewCell
        cell.selectionStyle = .none
        
        let movieInfo = realmManager.movieList[indexPath.row]
        cell.cellInfo = movieInfo
        cell.updateCell(movieInfo)
        cell.starButtonDelegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let refreshControl = favoritesTableView.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfo = realmManager.movieList[indexPath.row]
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movieInfo = movieInfo
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
