//
//  AtmProvider.swift
//  ATMinfo
//
//  Created by Vlad Kulakovsky  on 12.01.23.
//

import Foundation
import Moya

final class AtmProvider {
    private let provider = MoyaProvider<AtmApi>(plugins: [NetworkLoggerPlugin()])
    
    func getCurrency(city: String, succed: @escaping ([AtmModel]) -> Void, failure: @escaping (Error) -> Void) {
        provider.request(.getAtms(city: city)) { result in
            switch result {
                case .success(let response):
                    guard let atmInfo = try? JSONDecoder().decode([AtmModel].self, from: response.data) else { return }
                    succed(atmInfo)
                case .failure(let error):
                    print(error)
            }
        }
    }
}
