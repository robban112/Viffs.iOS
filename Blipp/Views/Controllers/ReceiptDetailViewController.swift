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

class ReceiptDetailViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  // will be set by the Coordinator
  var viewModel: ReceiptDetailViewModelType!
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet weak var backButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindUIToViewModel()
    bindViewModelToUI()
  }
  
  func bindUIToViewModel() {
    backButton.rx.tap
      .bind(to: viewModel.inputs.backButtonPressed)
      .disposed(by: disposeBag)
  }
  
  func bindViewModelToUI() {
    viewModel.outputs.receiptImage
      .asDriver(onErrorJustReturn: nil)
      .drive(imageView.rx.image)
      .disposed(by: disposeBag)
  }
}
