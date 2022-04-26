//
//  MockURLSession.swift
//  OpenMarketNetworkingTests
//
//  Created by 이윤주 on 2022/02/05.
//

import Foundation
@testable import OpenMarket

final class MockURLSession: URLSessionProtocol {
    
    var isSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?

    init(isSuccess: Bool = true) {
        self.isSuccess = isSuccess
    }

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(
            url: URL(string: "www.test.com")!,
            statusCode: 200,
            httpVersion: "2",
            headerFields: nil
        )
        let failureResponse = HTTPURLResponse(
            url: URL(string: "www.test.com")!,
            statusCode: 400,
            httpVersion: "2",
            headerFields: nil
        )

        let dataTask = MockURLSessionDataTask()
        var data: Data?

        if request.url == MarketEndPoint.getProductList(page: 1, numberOfItems: 10).configureURL() {
            let path = Bundle(for: type(of: self)).path(forResource: "ProductList", ofType: "json")
            data = try? String(contentsOfFile: path!).data(using: .utf8)
        } else if request.url == MarketEndPoint.getProduct(id: 1).configureURL() {
            let path = Bundle(for: type(of: self)).path(forResource: "Product", ofType: "json")
            data = try? String(contentsOfFile: path!).data(using: .utf8)
        }

        dataTask.resumDidCall = {
            self.isSuccess
            ? completionHandler(data, successResponse, nil)
            : completionHandler(nil, failureResponse, nil)
        }

        return dataTask
    }
}
