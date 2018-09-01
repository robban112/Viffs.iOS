//
//  ReceiptDetailViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-30.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReceiptDetailViewController: UIViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: ReceiptDetailViewModelType!
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet weak var backButton: UIButton!
  
  func bindViewModel() {
    bindViewModelToUI()
  }
  
  private func bindViewModelToUI() {
    viewModel.outputs.receiptImage
      .asDriver(onErrorJustReturn: nil)
      .drive(imageView.rx.image)
      .disposed(by: disposeBag)
  }
}
