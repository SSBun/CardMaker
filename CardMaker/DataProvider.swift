//
//  DataProvider.swift
//  CardMaker
//
//  Created by caishilin on 2021/7/13.
//

import Foundation
import Combine

class DataProvider {
    
    func request(_ url: URL, method: HTTPMethod = .get, body: Data?) -> URLSession.DataTaskPublisher {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if method == .post, let body = body, !body.isEmpty {
            request.httpBody = body
        }
        return URLSession(configuration: .default).dataTaskPublisher(for: request)
    }
    
    func request<Model: Decodable>(_ url: URL, method: HTTPMethod = .get, body: Data?) -> AnyPublisher<Model, HTTPError> {
        let subject = PassthroughSubject<Model, HTTPError>()
        let token = SubscriptionToken()
        request(url, method: method, body: body).sink { completion in
            token.unseal()
            if case .failure(let error) = completion {
                subject.send(completion: .failure(.networkError(error: error)))
            } else {
                subject.send(completion: .finished)
            }
        } receiveValue: { (data: Data, response: URLResponse) in
            if let result = try? JSONDecoder().decode(Model.self, from: data) {
                subject.send(result)
            } else {
                subject.send(completion: .failure(.modelTransformFailure(originalData: data)))
            }
        }
        .seal(in: token)
        return subject.eraseToAnyPublisher()
    }        
}

extension DataProvider {
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
    }
    enum HTTPError: Error {
        case networkError(error: Error)
        case modelTransformFailure(originalData: Data)
    }
}
