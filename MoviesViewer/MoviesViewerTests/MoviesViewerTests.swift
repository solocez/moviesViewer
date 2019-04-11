//
//  MoviesViewerTests.swift
//  MoviesViewerTests
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//  Copyright © 2019 solocez. All rights reserved.
//

import XCTest
@testable import MoviesViewer

extension MoviesViewerTests: AppManagersConsumer { }
class MoviesViewerTests: MoviesViewerXCTestCaseBase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovies() {
        let exp = expectation(description: "Moviess")
        
        appManagers.rest.nowPlaying(page: 4).subscribe(onSuccess: { (movies) in
            defer { exp.fulfill() }
            XCTAssert(!movies.results.isEmpty)
        }) { (err) in
            defer { exp.fulfill() }
            Log.error("\(err)")
            XCTFail()
            }.disposed(by: bag)
        XCTAssert(wait() == nil)
    }
    
    func testPosterDownload() {
        let exp = expectation(description: "testPosterDownload")
        
        let movie = Movie(title: "Shazam!"
            , posterPath: "/xnopI5Xtky18MPhK40cZAGAOVeV.jpg"
            , overview: "A boy is given the ability to become an adult superhero in times of need with a single magic word.")
        appManagers.rest.downloadPoster(for: movie).subscribe(onSuccess: { (img) in
            exp.fulfill()
        }) { (err) in
            defer { exp.fulfill() }
            Log.error("\(err)")
            XCTFail()
            }.disposed(by: bag)
        XCTAssert(wait() == nil)
    }

}
