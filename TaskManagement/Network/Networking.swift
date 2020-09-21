//
//  Networking.swift
//  TemaManagement
//
//  Created by Richard Stewart on 2020/8/28.
//  Copyright © 2020 Richard Stewart. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Result<Data: Decodable> {
    case success(Data)
    case failure(String)
}

typealias Handler = (Result<Data>) -> Void

protocol Requestable {}

extension Requestable {
    // Login & Register API. No Token
    internal func authRequest(url: String, params: Parameters?, callback: @escaping Handler) {
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in

            switch response.response?.statusCode {
            case 200:
                callback(.success(response.data!))
                break
            case 400:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 401:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 500:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            default:
                callback(.failure("Unexpected Error"))
                break;
            }
        }
    }
    
    // General API.Set Token
    internal func request(method: HTTPMethod, url: String, params: Parameters?, callback: @escaping Handler) {
        if !AuthManager.shared.hasValidToken {
            callback(.failure("Token Invalid Error"))
            return;
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer " + AuthManager.shared.token!
        ]
        
        AF.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in

            switch response.response?.statusCode {
            case 200:
                callback(.success(response.data!))
                break
            case 400:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 401:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            case 500:
                let result = JSON(response.data!)
                callback(.failure(result["message"].stringValue))
                break;
            default:
                callback(.failure("Unexpected Error"))
                break;
            }
        }
    }
}

