//
//  RESTManager.swift

import Foundation
import Alamofire
import RxSwift
import Reachability

//
protocol RESTManager {
    func nowPlaying(page: Int) -> Single<Movies>
}

//
final class RESTManagerImpl: RESTManager {
    
    private let networkQueue = DispatchQueue(label: "com.solocez.api.network", qos: .background, attributes: .concurrent)
    private var reachability = Reachability()! // It's ok for test task

    //
    func nowPlaying(page: Int) -> Single<Movies> {
        return Single<Movies>.create(subscribe: { [unowned self] (observer) in
            guard self.reachability.isReachable else {
                observer(.error(AppError(title: R.string.loc.error(), description: "NO CONNECTION", code: -1)))
                return Disposables.create()
            }
            
            guard var url = URL(string: Settings().RESTEndpoint) else {
                observer(.error(AppError(title: R.string.loc.error(), description: "FAILED TO CONSTRUCT URL REQUEST", code: 1)))
                return Disposables.create()
            }
            
            url = url.appending("api_key", value: Settings().apiKey)
            url = url.appending("page", value: String(page))
            
            Log.debug("RETRIEVING MOVIES: \(url.absoluteString)")
            
            Alamofire.request(url, method: .get)
                .validate()
                .responseJSON(queue: self.networkQueue) { response in
                    guard response.result.isSuccess else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "ALL COUNTRIES REQUEST FAILURE", code: 2)))
                        return
                    }
                    
                    guard let data = response.data else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "NO DATA TO DECODE", code: 3)))
                        return
                    }
                    
                    guard let result = try? JSONDecoder().decode(Movies.self, from: data) else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "COULD NOT DECODE RESPONSE", code: 4)))
                        return
                    }
                    
                    observer(.success(result))
            }
            return Disposables.create()
        })
    }
}

