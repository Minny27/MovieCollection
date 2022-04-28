//
//  MovieTableViewCell.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    weak var starButtonDelegate: StarButtonDelegate?
    var cellInfo: MovieTableViewCellModel?
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let starButton: UIButton = {
        let button = UIButton()
        button.setTitle("★", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(
            self,
            action: #selector(clickStarButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        containerView.addSubview(movieImageView)
        movieImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        movieImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        movieImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        containerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10).isActive = true
        
        containerView.addSubview(starButton)
        starButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        starButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        starButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        starButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30).isActive = true
        
        stackView.addArrangedSubview(directionLabel)
        directionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30).isActive = true
        
        stackView.addArrangedSubview(actorsLabel)
        actorsLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        stackView.addArrangedSubview(ratingLabel)
        ratingLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    }
    
    func updateCell(_ movieInfo: MovieTableViewCellModel?) {
        movieImageView.setupMovieImage(from: movieInfo?.imageUrlString ?? "")
        titleLabel.text = movieInfo?.title ?? ""
        directionLabel.text = "감독: " + (movieInfo?.director ?? "")
        actorsLabel.text = "출연: " + (movieInfo?.actors ?? "")
        ratingLabel.text = "평점: " + (movieInfo?.rating ?? "")
        starButton.setTitleColor(getButtonColor(movieInfo?.isFavorites ?? false), for: .normal)
    }
    
    func getButtonColor(_ isFavorites: Bool) -> UIColor {
        return isFavorites == true ? .systemYellow : .lightGray
    }
    
    @objc func clickStarButton() {
        if cellInfo != nil {
            if cellInfo!.isFavorites {
                starButton.setTitleColor(.lightGray, for: .normal)
                cellInfo!.isFavorites = false
                starButtonDelegate?.updateDataBase(cellInfo!, .off)
            } else {
                starButton.setTitleColor(.systemYellow, for: .normal)
                cellInfo!.isFavorites = true
                starButtonDelegate?.updateDataBase(cellInfo!, .on)
            }
        }
    }
}
