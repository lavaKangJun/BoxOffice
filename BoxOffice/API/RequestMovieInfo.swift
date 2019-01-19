
//  ResuestMovieInfo.swift
//  BoxOffice
//
//  Created by 강준영 on 10/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation

let baseURL = "http://connect-boxoffice.run.goorm.io/"

func movieInfoRequest<T: Decodable>(urlString: String, value: String ,completion: @escaping (Bool, Error?, T?) -> ()) {
    guard let url: URL = URL(string: urlString + value) else {
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


