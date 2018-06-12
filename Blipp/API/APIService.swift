//
//  APIService.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-09.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import Result

enum APIServiceError: Error {
  case imageDownload(String)
}

// struct that will contain all the methods for working with the API/Database
struct APIService {
  // OBS: temporary solution
  var image: (Receipt) -> Single<Result<UIImage?, APIServiceError>>
}

func image(for receipt: Receipt) -> Single<Result<UIImage?, APIServiceError>> {
  return Single.create(subscribe: { single -> Disposable in
    guard let url = URL.init(string: receipt.url) else { return Disposables.create() }
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data) else {
          single(.success(.failure(.imageDownload(""))))
          return
      }
      single(.success(.success(image)))
      }.resume()
    return Disposables.create()
  })
}

extension APIService {
  static var live: APIService {
    return APIService(image: image(for:))
  }
}
