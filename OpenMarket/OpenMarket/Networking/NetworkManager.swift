//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/19.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFail(Error)
    case invalidResponse
    case failedResponse(statusCode: Int)
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFail:
            return "HTTP 요청에 실패했습니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .failedResponse:
            return "실패한 상태 코드를 받았습니다: \n"
        case .emptyData:
            return "데이터가 존재하지 않습니다."
        }
    }
}

final class NetworkManager: NetworkManageable {

    private let session: URLSession
    private let successStatusCode: Range<Int> = (200 ..< 300)
    private let multipartFormData: MultipartFormData

    init(session: URLSession = .shared, multipartFormData: MultipartFormData = .init()) {
        self.session = session
        self.multipartFormData = multipartFormData
    }

    func performDataTask(with request: URLRequest,
                         completion: @escaping SessionResult) {        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFail(error)))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard self.successStatusCode.contains(httpResponse.statusCode) else {
                completion(.failure(.failedResponse(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
    
    func request(to endPoint: EndPointType,
                 completion: @escaping SessionResult) {
        guard let url = endPoint.configureURL() else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url)
        performDataTask(with: request, completion: completion)
    }
    
    func request(to endPoint: EndPointType,
                 with body: BodyParameterType,
                 completion: @escaping SessionResult) {
        guard let url = endPoint.configureURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let encoded = multipartFormData.encode(body)
        let request = URLRequest(url: url,
                                 endPoint: endPoint,
                                 contentType: multipartFormData.contentType,
                                 httpBody: encoded)
        performDataTask(with: request, completion: completion)
    }
}
