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
    
    static let background = Settings().backgroundColor
    static let padding: CGFloat = 20.0
    
    // MARK: Outlets
    private let scrollView = UIScrollView(frame: .zero)
    private let contentPanel = UIView(frame: .zero)
    private let posterImageView = UIImageView(frame: .zero)
    
    private let score = InfoItem(frame: .zero)
    private let rating = InfoItem(frame: .zero)
    private let releaseDate = InfoItem(frame: .zero)
    
    private let titleLbl = UILabel(frame: .zero)
    private let delimeter = UIView(frame: .zero)
    private let overviewLbl = UILabel(frame: .zero)
    private let delimeter2 = UIView(frame: .zero)
    
    // MARK: Object lifecycle
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setupPoster()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.setNeedsUpdateConstraints()
        posterImageView.setNeedsUpdateConstraints()
    }
    
    // MARK: Setup
    
    //
    override func setupUI() {
        title = viewModel.output.movie.title
        view.backgroundColor = MovieViewController.background
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = UIColor.gray
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        setupScrollView()
        setupContentPanel()
        setupPoster()
        setupInfoItems()
        setupTitle()
        setupDelimeter(delimeter: delimeter, topNeighbourVIew: titleLbl)
        setupOverview()
        setupDelimeter(delimeter: delimeter2, topNeighbourVIew: overviewLbl, bindScroll: true)
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
        overviewLbl.text = viewModel.output.movie.overview
    }
}

//
extension MovieViewController {
    
    //
    private func setupOverview() {
        contentPanel.addSubview(overviewLbl)
        overviewLbl.numberOfLines = 0
        overviewLbl.font = UIFont.systemFont(ofSize: 18.0)
        overviewLbl.textColor = UIColor.white
        overviewLbl.textAlignment = .natural
        overviewLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(delimeter.snp.bottom).inset(0 - MovieViewController.padding * 2)
        }
    }
    
    //
    private func setupDelimeter(delimeter: UIView, topNeighbourVIew: UIView, bindScroll: Bool = false) {
        contentPanel.addSubview(delimeter)
        delimeter.backgroundColor = UIColor.gray
        delimeter.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topNeighbourVIew.snp.bottom).inset(0 - MovieViewController.padding * 2)
            make.height.equalTo(2)
            if bindScroll {
                make.bottom.equalTo(contentPanel.snp.bottom)
            }
        }
    }
    
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
        posterImageView.snp.remakeConstraints { (make) in
            if UIDevice.current.orientation.isLandscape {
                make.leading.top.equalToSuperview()
                make.width.equalTo(view.frame.width / 4)
                make.height.equalTo(view.frame.height / 4 * 3)
            } else {
                make.leading.top.equalToSuperview()
                make.width.equalTo(view.frame.width / 2.3)
                make.height.equalTo(view.frame.height / 3)
            }
        }
        
        if let posterURL = viewModel.output.movie.posterURL() {
            posterImageView.af_setImage(withURL: posterURL, placeholderImage: R.image.posterPlaceholder())
        }
    }
    
    //
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //
    private func setupContentPanel() {
        contentPanel.backgroundColor = MovieViewController.background
        scrollView.addSubview(contentPanel)
        contentPanel.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(MovieViewController.padding)
            make.leading.equalToSuperview().inset(MovieViewController.padding)
            make.width.equalToSuperview().inset(MovieViewController.padding)
        }
    }
}

