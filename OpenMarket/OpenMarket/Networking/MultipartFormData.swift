//
//  MultipartFormData.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/20.
//

import Foundation
import UIKit

final class MultipartFormData {

    enum EncodingCharacter {
        static let crlf = "\r\n"
    }

    enum BoundaryGenerator {
        enum BoundaryType {
            case initial, encapsulated, final
        }

        static func boundaryData(for boundaryType: BoundaryType, boundary: String) -> Data {
            let boundaryText: String

            switch boundaryType {
            case .initial:
                boundaryText = "--\(boundary)\(EncodingCharacter.crlf)"
            case .encapsulated:
                boundaryText = "\(EncodingCharacter.crlf)--\(boundary)\(EncodingCharacter.crlf)"
            case .final:
                boundaryText = "\(EncodingCharacter.crlf)--\(boundary)--\(EncodingCharacter.crlf)"
            }

            return Data(boundaryText.utf8)
        }
    }

    let boundary = "NalaMarketBoundary-" + UUID().uuidString
    lazy var contentType = "multipart/form-data; boundary=\(self.boundary)"
    let imageMimeType = "image/jpeg"
    private var body = Data()

    func encode(json: Data, images: [Data]) -> Data {
        appendJSON(withName: "params", from: json)
        appendImages(withName: "images", from: images)
        
        body.append(finalBoundaryData())
        return body
    }

    private func appendJSON(withName name: String, from data: Data) {
        body.isEmpty ? body.append(initialBoundaryData()) : body.append(encapsulatedBoundaryData())

        body.append(contentHeaders(withName: name))
        body.append(data)
    }

    private func appendImages(withName name: String, from datas: [Data]) {
        for index in datas.indices {
            body.isEmpty ? body.append(initialBoundaryData()) : body.append(encapsulatedBoundaryData())
            
            let fileName = "image\(index).jpeg"
            body.append(contentHeaders(withName: name, fileName: fileName, mimeType: imageMimeType))
            body.append(datas[index])
        }
    }

    private func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> Data {
        var disposition = "form-data; name=\"\(name)\""
        if let fileName = fileName {
            disposition += "; fileName=\"\(fileName)\"" + EncodingCharacter.crlf
        }

        var headers = "Content-Disposition: \(disposition)"
        if let mimeType = mimeType {
            headers.append("Content-Type: \(mimeType)" + EncodingCharacter.crlf + EncodingCharacter.crlf)
        }

        return Data(headers.utf8)
    }

    private func initialBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(for: .initial, boundary: boundary)
    }

    private func encapsulatedBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(for: .encapsulated, boundary: boundary)
    }

    private func finalBoundaryData() -> Data {
        BoundaryGenerator.boundaryData(for: .final, boundary: boundary)
    }
}