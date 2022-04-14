//
//  ViewController.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import UIKit

class HomeViewController: UIViewController {

    // Properties
    let movieTableViewModel = MovieTableViewModel()
    
    let movieTableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.sectionHeaderTopPadding = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationController()
        setupMovieTableView()
        
        movieTableViewModel.fetchMovieData()
        
        movieTableViewModel.movieList.bind { _ in
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "네이버 영화 검색"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "⭐️ 즐겨찾기",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupMovieTableView() {
        view.addSubview(movieTableView)
        
        movieTableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        movieTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        movieTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        movieTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        movieTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTableViewModel.movieList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as! MovieTableViewCell
        
        if let movieInfo = movieTableViewModel.movieList.value?[indexPath.row] {
            cell.setupCell()
            cell.updateCell(movieInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
