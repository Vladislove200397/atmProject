//
//  AtmApi.swift
//  ATMinfo
//
//  Created by Vlad Kulakovsky  on 12.01.23.
//

import Foundation
import Moya
 
enum AtmApi {
    case getAtms(city: String)
}

extension AtmApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://belarusbank.by/api/atm")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        var params = [String: Any]()
        switch self {
            case .getAtms(city: let city):
                params["city"] = city
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .getAtms:
                return URLEncoding.queryString
        }
    }
    
    var task: Moya.Task {
        guard let parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

