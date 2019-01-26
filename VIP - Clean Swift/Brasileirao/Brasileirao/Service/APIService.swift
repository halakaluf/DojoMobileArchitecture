//
//  APIService.swift
//  Brasileirao
//
//  Created by Fabio Martinez on 18/12/2018.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    private init() {}
    
    public static let shared = APIService()

    typealias GetMatchesCompletion = (_ result: [Match]) -> Void
    
    func getMatches(round: Int, completion: @escaping (_ result: Any) -> Void) {
        URLCache.shared.removeAllCachedResponses() //evitando cache
        AF.request("https://api.globoesporte.globo.com/tabela/d1a37fa4-e948-43a6-ba53-ab24ab3a45b1/fase/fase-unica-seriea-2018/rodada/\(round)/jogos/")
            .validate()
            .responseJSON { response in
                if let data = response.data {
                    do {
                        let matches = try [Match].decode(data: data)
                        completion(matches)
                    } catch {
                        completion(error)
                    }
                    
                } else {
                    completion(response.result.error!)
                }
        }
    }
    
    func getMatchResume(url: String, completion: @escaping (_ result: Any) -> Void) {
        URLCache.shared.removeAllCachedResponses() //evitando cache
        AF.request("https://lalmartinez.herokuapp.com/?url=\(url)")
            .validate()
            .responseJSON { response in
                if let data = response.data {
                    do {
                        let bids = try [Bid].decode(data: data)
                        completion(bids)
                    } catch {
                        completion(error)
                    }
                    
                } else {
                    completion(response.result.error!)
                }
        }
    }
}
