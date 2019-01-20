
//  ResuestMovieInfo.swift
//  BoxOffice
//
//  Created by 강준영 on 10/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation

enum RequestType {
    case movieList
    case movieDetail
    case movieComment
}

class MovieAPI {
    private let baseURL = "http://connect-boxoffice.run.goorm.io/"
    static let shared = MovieAPI()

    func movieInfoRequest<T: Decodable>(requestType: RequestType, value: String ,completion:
        @escaping (Bool, Error?, T?) -> ()) {
        
        guard let url: URL = URL(string: makeURL(type: requestType, parameter: value)) else {
            return
        }
        let session: URLSession = URLSession.init(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let movieInfoResponse: T = try JSONDecoder().decode(T.self, from: data)
                completion(true, nil, movieInfoResponse)
            } catch (let error){
                print(error.localizedDescription)
                completion(false, error, nil)
            }
        }
        dataTask.resume()
    }
    
    private func makeURL(type: RequestType, parameter: String) -> String {
        switch type {
        case .movieList:
            return baseURL + "movies?order_type=\(parameter)"
        case .movieDetail:
            return baseURL + "movie?id=\(parameter)"
        case .movieComment:
            return baseURL + "comments?movie_id=\(parameter)"
        }
    }
    
}
