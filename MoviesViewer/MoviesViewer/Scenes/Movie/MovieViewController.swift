//
//  MovieViewController.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-13.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

//
final class MovieViewController: BaseMVVMViewController<MovieViewModel> {
    
    static let background = UIColor.green
    static let padding: CGFloat = 20.0
    
    // MARK: Outlets
    private let contentPanel = UIView(frame: .zero)
    private let posterImageView = UIImageView(frame: .zero)
    
    private let score = InfoItem(frame: .zero)
    private let rating = InfoItem(frame: .zero)
    private let releaseDate = InfoItem(frame: .zero)
    
    private let titleLbl = UILabel(frame: .zero)
    
    // MARK: Object lifecycle
    
    // MARK: Setup
    
    //
    override func setupUI() {
        view.backgroundColor = UIColor.red
        setupContentPanel()
        setupPoster()
        setupInfoItems()
        setupTitle()
    }
    
    //
    override func setupBindings() {
        if let posterURL = viewModel.output.movie.posterURL() {
            posterImageView.af_setImage(withURL: posterURL, placeholderImage: R.image.posterPlaceholder())
        }
        score.data = String(viewModel.output.movie.voteAverage)
        rating.data = String(viewModel.output.movie.popularity)
        if let tmp = DateFormatter.releaseDateRecord().date(from: viewModel.output.movie.releaseDate) {
            releaseDate.data = DateFormatter.releaseDateFormat().string(from: tmp)
        } else {
            releaseDate.data = "Unknown"
        }
        
        titleLbl.text = viewModel.output.movie.title
    }
}

//
extension MovieViewController {
    //
    private func setupTitle() {
        contentPanel.addSubview(titleLbl)
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont.boldSystemFont(ofSize: 40.0)
        titleLbl.textColor = UIColor.white
        titleLbl.textAlignment = .center
        titleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(posterImageView.snp.bottom).inset(0 - MovieViewController.padding * 2)
        }
    }
    
    //
    private func setupInfoItems() {
        contentPanel.addSubview(score)
        score.title = "Score:"
        score.data = "Unknown"
        score.backgroundColor = MovieViewController.background
        score.snp.makeConstraints { (make) in
            make.leading.equalTo(posterImageView.snp.trailing).inset(0 - MovieViewController.padding)
            make.top.equalTo(posterImageView.snp.top)
            make.trailing.equalToSuperview()
        }
        
        contentPanel.addSubview(rating)
        rating.title = "Rating:"
        rating.data = "Unknown"
        rating.backgroundColor = MovieViewController.background
        rating.snp.makeConstraints { (make) in
            make.leading.equalTo(posterImageView.snp.trailing).inset(0 - MovieViewController.padding)
            make.centerY.equalTo(posterImageView.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        contentPanel.addSubview(releaseDate)
        releaseDate.title = "Release Date:"
        releaseDate.data = "Unknown"
        releaseDate.backgroundColor = MovieViewController.background
        releaseDate.snp.makeConstraints { (make) in
            make.leading.equalTo(posterImageView.snp.trailing).inset(0 - MovieViewController.padding)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(posterImageView.snp.bottom)
        }
    }
    
    //
    private func setupPoster() {
        contentPanel.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.equalTo(view.frame.width / 2.3)
            make.height.equalTo(view.frame.height / 3)
        }
        
        if let posterURL = viewModel.output.movie.posterURL() {
            posterImageView.af_setImage(withURL: posterURL, placeholderImage: R.image.posterPlaceholder())
        }
    }
    
    //
    private func setupContentPanel() {
        contentPanel.backgroundColor = UIColor.yellow
        view.addSubview(contentPanel)
        contentPanel.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(MovieViewController.padding)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(MovieViewController.padding)
        }
    }
}

