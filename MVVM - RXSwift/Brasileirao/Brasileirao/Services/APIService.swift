//
//  APIService.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class APIService {
    
    private init() {}
    
    public static let shared = APIService()
     
    func getMatches(round: Int) -> Observable<[Match]> {
        return Observable.create { observer -> Disposable in
            URLCache.shared.removeAllCachedResponses() //evitando cache
            AF.request("https://api.globoesporte.globo.com/tabela/d1a37fa4-e948-43a6-ba53-ab24ab3a45b1/fase/fase-unica-campeonato-brasileiro-2021/rodada/\(round)/jogos/")
                .validate()
                .responseJSON { response in
                    switch response.result {
                        case .success( _):
                            do {
                                let matches = try [Match].decode(data: response.data!)
                                observer.onNext(matches)
                            } catch {
                                observer.onError(error)
                            }
                        case let .failure(error):
                            observer.onError(error)
                    }
                }
            return Disposables.create()
        }

    }

    func getMatchResume(url: String) -> Observable<[Bid]> {
        return Observable.create { observer -> Disposable in
            URLCache.shared.removeAllCachedResponses() //evitando cache
            AF.request("https://gecrawler.herokuapp.com/?url=\(url)")
                .validate()
                .responseJSON { response in
                    if let data = response.data {
                        do {
                            let bids = try [Bid].decode(data: data)
                            observer.onNext(bids)
                        } catch {
                            observer.onError(error)
                        }
                        
                    } else {
                        observer.onError(response.error!)
                    }
            }
            return Disposables.create()
        }
    }
}

extension APIServiceRx: ReactiveCompatible {}

class APIServiceRx {
    init () {}
}

extension Reactive where Base: APIServiceRx {
    
   static func getMatches(round: Int) -> Observable<Result<[Match]>> {
       return Observable.create { observer -> Disposable in
           URLCache.shared.removeAllCachedResponses() //evitando cache
           AF.request("https://api.globoesporte.globo.com/tabela/d1a37fa4-e948-43a6-ba53-ab24ab3a45b1/fase/fase-unica-campeonato-brasileiro-2021/rodada/\(round)/jogos/")
               .validate()
               .responseJSON { response in
                   switch response.result {
                       case .success( _):
                           do {
                               let matches = try [Match].decode(data: response.data!)
                                observer.onNext(Result.success(matches))
                           } catch {
                            observer.onNext(Result.failure(error))
                           }
                       case let .failure(error):
                        observer.onNext(Result.failure(error))
                   }
                observer.onCompleted()
               }
           return Disposables.create()
       }

   }

    static func getMatchResume(url: String) -> Observable<Result<[Bid]>> {
       return Observable.create { observer -> Disposable in
           URLCache.shared.removeAllCachedResponses() //evitando cache
           AF.request("https://gecrawler.herokuapp.com/?url=\(url)")
               .validate()
               .responseJSON { response in
                   if let data = response.data {
                       do {
                           let bids = try [Bid].decode(data: data)
                            observer.onNext(Result.success(bids))
                       } catch {
                            observer.onNext(Result.failure(error))
                       }
                       
                   } else {
                        observer.onNext(Result.failure(response.error!))
                   }
                
                observer.onCompleted()
           }
           return Disposables.create()
       }
   }
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {
    var value: T? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var failure: Error? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
