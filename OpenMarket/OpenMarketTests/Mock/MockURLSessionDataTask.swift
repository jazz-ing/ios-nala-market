//
//  MockURLSessionDataTask.swift
//  OpenMarketNetworkingTests
//
//  Created by 이윤주 on 2022/02/05.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumDidCall: () -> Void = {}
    
    override func resume() {
        resumDidCall()
    }
}
