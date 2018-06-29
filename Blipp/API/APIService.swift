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
  
  var receipts: () -> Single<[Receipt]>
  
  // OBS: this is if we want to handle this logic at the server side
  var isValidPassword: (String) -> Single<Bool>
}

func image(for receipt: Receipt) -> Single<Result<UIImage?, APIServiceError>> {
  return Single.create(subscribe: { single -> Disposable in
    guard let url = URL.init(string: receipt.url) else { return Disposables.create() }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data) else {
          single(.success(.failure(.imageDownload(""))))
          return
      }
      single(.success(.success(image)))
    }
    task.resume()
    return Disposables.create {
      task.cancel()
    }
  })
}

func getReceipts() -> Single<[Receipt]> {
  // OBS: Should use server when it's up, now just mock data
  return Single.just([
    Receipt(currency: "SEK", name: "Pressbyrån", total: 65, url: "http://photos1.blogger.com/blogger/7644/1950/1600/guns.0.jpg"),
    Receipt(currency: "SEK", name: "Pressbyrån", total: 23, url: "http://cdn1.cdnme.se/cdn/6-2/860557/images/2012/skarmavbild-2012-03-28-kl-20-16-11_195949945.png")
  ])
}

func isValidPwd(password: String) -> Single<Bool> {
  // Dummy implementation right now because this functionality does not exist in the server
  return .just(password.count > 4)
}

extension APIService {
  static var live: APIService {
    return APIService(image: image(for:), receipts: getReceipts, isValidPassword: isValidPwd)
  }
}
