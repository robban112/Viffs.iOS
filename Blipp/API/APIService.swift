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

//Placeholder function
func imageFromFile(for receipt: Receipt) -> UIImage {
  if let image = UIImage(named: receipt.url) {
    return image
  } else {
    return #imageLiteral(resourceName: "Blue Green Circle Gradient Android Wallpaper")
  }
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
  return Single.just(Current.currentUser?.receipts ?? [])
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
