//
//  WeatherAPIClient.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 24/06/2021.
//

import Foundation
import UIKit


class WeatherAPIClient {
    // ENDPOINTS ENUM: Stores my url as string and then transforms it to URL type.
    enum Endpoints{
        static let base = "https://api.weatherapi.com"
        
        case weatherCurrent
        
        var stringValue:String {
            switch self {
            case .weatherCurrent: return Endpoints.base + "/v1/current.json?key=b53d27347d644df3a8c91427212406&q=Stokmarknes&aqi=no"
            }
        }
        
        // Make url from string.
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    // Requests from an URL the data with a specified type and handles the errors.
    // It uses the main thread to give the completion.
    class func taskForGETRequest<ResponseType:Decodable>(url:URL, response:ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
        
        // Request data from the url.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async{
                    completion(nil, error)
                }
                return
            }
            // If request was successful, try do decode the data using the ResponseType.
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
            }
        }
        task.resume()
        return task
    }
}
