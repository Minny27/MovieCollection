//
//  MovieDetailVIewController.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/14.
//

import WebKit
import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    var movieInfo: MovieTableViewCellModel?
    
    let movieDetailTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let movieDetailWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupNavigationController()
        setupMovieDetailTableView()
        setupMovieDetailWebView(urlString: movieInfo?.linkString)
    }
    
    func setupNavigationController() {
        navigationItem.title = movieInfo?.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(clickBackButton)
        )
    }
    
    func setupMovieDetailTableView() {
        view.addSubview(movieDetailTableView)
        movieDetailTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        movieDetailTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        movieDetailTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        movieDetailTableView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        movieDetailTableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
        
        movieDetailTableView.dataSource = self
        movieDetailTableView.delegate = self
    }
    
    func setupMovieDetailWebView(urlString: String?) {
        view.addSubview(movieDetailWebView)
        movieDetailWebView.topAnchor.constraint(equalTo: movieDetailTableView.bottomAnchor).isActive = true
        movieDetailWebView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        movieDetailWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        movieDetailWebView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        guard let url = URL(string: urlString ?? "") else {
            print(NetworkError.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        movieDetailWebView.load(request)
    }
    
    @objc func clickBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as! MovieTableViewCell
        cell.selectionStyle = .none
        cell.setupCell()
        cell.updateCell(movieInfo)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
