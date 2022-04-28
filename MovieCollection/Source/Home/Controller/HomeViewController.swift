//
//  ViewController.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    let movieTableViewModel = MovieTableViewModel()
    let realmManager = RealmManager.shared
    let customActivityIndicatorView = CustomActivityIndicatorView()
    
    let movieSearchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.isTranslucent = false
        sb.setImage(UIImage(), for: .search, state: .normal)
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "영화 제목을 입력해보세요.",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.tintColor = .black
        sb.searchTextField.layer.borderWidth = 1
        sb.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        sb.searchTextField.layer.cornerRadius = 5
        sb.backgroundImage = UIImage()
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    let movieTableView: UITableView = {
        let tv = UITableView()
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.sectionHeaderTopPadding = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationController()
        setupMovieSearchBar()
        setupMovieTableView()
        setupLoadingView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movieTableView.reloadData()
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32 - 90, height: view.frame.height))
        titleLabel.text = "네이버 영화 검색"
        titleLabel.font = .boldSystemFont(ofSize: 22)
        navigationItem.titleView = titleLabel
        
        let buttonLabel = UILabel()
        buttonLabel.text = "★즐겨찾기"
        buttonLabel.textAlignment = .center
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: buttonLabel.text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemYellow, range: (buttonLabel.text! as NSString).range(of: "★"))
        buttonLabel.attributedText = attributedString
        
        let starButton = UIButton()
        starButton.setTitle(buttonLabel.text, for: .normal)
        starButton.setTitleColor(.clear, for: .normal)
        starButton.layer.borderWidth = 0.5
        starButton.layer.borderColor = UIColor.lightGray.cgColor
        starButton.addTarget(
            self,
            action: #selector(clickFavoritesButton),
            for: .touchUpInside
        )
        
        starButton.addSubview(buttonLabel)
        buttonLabel.centerXAnchor.constraint(equalTo: starButton.centerXAnchor).isActive = true
        buttonLabel.centerYAnchor.constraint(equalTo: starButton.centerYAnchor).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: starButton)
    }
    
    func setupMovieSearchBar() {
        view.addSubview(movieSearchBar)
        movieSearchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        movieSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        movieSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true

        movieSearchBar.delegate = self
    }
    
    func setupMovieTableView() {
        view.addSubview(movieTableView)
        movieTableView.topAnchor.constraint(equalTo: movieSearchBar.bottomAnchor).isActive = true
        movieTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        movieTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        movieTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        movieTableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
    
    func setupLoadingView() {
        movieTableView.addSubview(customActivityIndicatorView)
        customActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        customActivityIndicatorView.centerXAnchor.constraint(equalTo: movieTableView.centerXAnchor).isActive = true
        customActivityIndicatorView.centerYAnchor.constraint(equalTo: movieTableView.centerYAnchor).isActive = true
        customActivityIndicatorView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customActivityIndicatorView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func fetchData() {
        movieTableViewModel.fetchMovieData()
        
        movieTableViewModel.movieList.bind { _ in
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }
    
    @objc func clickFavoritesButton() {
        let favoritesViewController = FavoritesViewController()
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}

// MARK: - StarButtonDelegate
extension HomeViewController: StarButtonDelegate {
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
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTableViewModel.movieList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as! MovieTableViewCell
        cell.selectionStyle = .none
        
        if var movieInfo = movieTableViewModel.movieList.value?[indexPath.row] {
            customActivityIndicatorView.loadingView.stopAnimating()
            movieInfo.isFavorites = self.realmManager.checkFavorites(movieInfo: movieInfo)
            cell.cellInfo = movieInfo
            cell.updateCell(movieInfo)
            cell.starButtonDelegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var movieInfo = movieTableViewModel.movieList.value?[indexPath.row] {
            movieInfo.isFavorites = realmManager.checkFavorites(movieInfo: movieInfo)
            let movieDetailViewController = MovieDetailViewController()
            movieDetailViewController.movieInfo = movieInfo
            navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Strings.keyword = searchText
        fetchData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movieSearchBar.searchTextField.resignFirstResponder()
    }
}
