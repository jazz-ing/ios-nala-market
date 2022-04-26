//
//  NetworkingTests.swift
//  OpenMarketTests
//
//  Created by 이윤주 on 2022/02/05.
//

import XCTest
@testable import OpenMarket

class NetworkingTests: XCTestCase {

    var decodingManager: DecodingManager?
    var networkManager: NetworkManager?

    override func setUpWithError() throws {
        decodingManager = DecodingManager()
        networkManager = NetworkManager(session: MockURLSession())
    }

    override func tearDownWithError() throws {
        decodingManager = nil
        networkManager = nil
    }

    func test_decode메소드호출시_json데이터파싱에성공하는지() {
        // given
        let jsonPath = Bundle(for: type(of: self)).path(forResource: "Product", ofType: "json")!
        guard let jsonData = try? String(contentsOfFile: jsonPath).data(using: .utf8) else {
            return
        }
        let expectedValue = "iPad"
        var outputValue: String?

        // when
        let decodedData = decodingManager!.decode(jsonData, to: Product.self)
        switch decodedData {
        case .success(let product):
            outputValue = product.name
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }

    func test_통신이성공했다고가정했을때_request호출시_상품정보를get하는데성공하는지() {
        // given
        let expectedValue = "iPad"
        var outputValue: String?

        // when
        networkManager?.request(to: MarketEndPoint.getProduct(id: 1)) { result in
            switch result {
            case .success(let data):
                let decodedData = self.decodingManager!.decode(data, to: Product.self)
                switch decodedData {
                case .success(let product):
                    outputValue = product.name
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }

    func test_통신이성공했다고가정했을때_request호출시_상품리스트를get하는데성공하는지() {
        // given
        let expectedValue = 1
        var outputValue: Int?

        // when
        networkManager?.request(
            to: MarketEndPoint.getProductList(page: 1, numberOfItems: 10)
        ) { result in
            switch result {
            case .success(let data):
                let decodedData = self.decodingManager!.decode(data, to: ProductList.self)
                switch decodedData {
                case .success(let productList):
                    outputValue = productList.pageNumber
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }

    func test_통신이실패했다고가정했을때_request호출시_실패코드에러를반환하는지() {
        // given
        networkManager = NetworkManager(session: MockURLSession(isSuccess: false))
        let expectedValue = NetworkError.failedResponse(statusCode: 400).localizedDescription
        var outputValue: String?

        // when
        networkManager?.request(to: MarketEndPoint.getProduct(id: 1)) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                outputValue = error.localizedDescription
            }
        }

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }

    func test_통신이실패했다고가정했을때_request호출시_상품리스트를get하는데실패하는지() {
        // given
        networkManager = NetworkManager(session: MockURLSession(isSuccess: false))
        let expectedValue = NetworkError.failedResponse(statusCode: 400).localizedDescription
        var outputValue: String?

        // when
        networkManager?.request(
            to: MarketEndPoint.getProductList(page: 1, numberOfItems: 10)
        ) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                outputValue = error.localizedDescription
            }
        }

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }

    func test_실제통신을진행했을때_request호출시_상품정보를get하는데성공하는지() {
        // given
        networkManager = NetworkManager()
        let expectedValue = "아이폰13"
        var outputValue: String?
        let expectation = XCTestExpectation(description: "NetworkManagerRequestExpectation")

        // when
        networkManager?.request(to: MarketEndPoint.getProduct(id: 521)) { result in
            switch result {
            case .success(let data):
                let decodedData = self.decodingManager!.decode(data, to: Product.self)
                switch decodedData {
                case .success(let product):
                    outputValue = product.name
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }

    func test_실제통신을진행했을때_request호출시_상품리스트를get하는데성공하는지() {
        // given
        networkManager = NetworkManager()
        let expectedValue = 1
        var outputValue: Int?
        let expectation = XCTestExpectation(description: "NetworkManagerRequestExpectation")

        // when
        networkManager?.request(
            to: MarketEndPoint.getProductList(page: 1, numberOfItems: 10)
        ) { result in
            switch result {
            case .success(let data):
                let decodedData = self.decodingManager!.decode(data, to: ProductList.self)
                switch decodedData {
                case .success(let productList):
                    outputValue = productList.pageNumber
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        // then
        XCTAssertEqual(outputValue, expectedValue)
    }
}
