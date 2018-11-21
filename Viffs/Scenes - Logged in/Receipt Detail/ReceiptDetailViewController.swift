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
import SkeletonView

class ReceiptDetailViewController: ViffsViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: ReceiptDetailViewModelType!
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet weak var backButton: UIButton!
  
  func bindViewModel() {
    bindViewModelToUI()
  }
  
  func setIsLoading() {
    imageView.showAnimatedGradientSkeleton()
  }
  
  func setIsNotLoading() {
    imageView.hideSkeleton()
  }
  
  private func bindViewModelToUI() {
    viewModel.outputs.receiptImage
      .asDriver(onErrorJustReturn: nil)
      .drive(imageView.rx.image)
      .disposed(by: disposeBag)
  }
}
