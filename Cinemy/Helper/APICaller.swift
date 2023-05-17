//
//  APICaller.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import Foundation
enum DataError : Error {
    case dataError
    case invalidURL
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping(Result<[Title],DataError>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(.dataError))
                return
            }
            do{
               let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func getTrendingTvs(completion: @escaping(Result<[Title],DataError>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(.dataError))
                return
            }
            do{
               let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func getUpcomingMovies(completion: @escaping(Result<[Title],DataError>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(.dataError))
                return
            }
            do{
               let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    func getPopular(completion: @escaping(Result<[Title],DataError>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(.dataError))
                return
            }
            do{
               let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    func getTopRated(completion: @escaping(Result<[Title],DataError>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(.dataError))
                return
            }
            do{
               let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    //        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }

    
    func getDiscoverMovies(completion: @escaping(Result<[Title],DataError>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(.dataError))
                return
            }
            do{
               let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    func search(with query: String, completion: @escaping (Result<[Title], DataError>) -> Void) {
            
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
                
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))

            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
