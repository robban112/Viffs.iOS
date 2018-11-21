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
import SwiftGifOrigin

class ReceiptDetailViewController: ViffsViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: ReceiptDetailViewModelType!
    
    @IBOutlet var loadingImage: UIImageView!
    @IBOutlet var imageView: UIImageView!
  @IBOutlet weak var backButton: UIButton!
  
  func bindViewModel() {
    bindViewModelToUI()
  }
  
  func setIsLoading() {
    //imageView.showAnimatedGradientSkeleton()
    let gif = UIImage.gif(name: "Loading-Spinner")
    loadingImage.image = gif
  }
  
  @objc func setIsNotLoading() {
    loadingImage.image = nil
  }
  
  override func viewDidLoad() {
    setObservers()
    setIsLoading()
    
  }
  
  func setObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(setIsNotLoading), name: Notification.Name("ReceiptImageSet"), object: nil)
  }
  
  private func bindViewModelToUI() {
    viewModel.outputs.receiptImage
      .asDriver(onErrorJustReturn: nil)
      .drive(imageView.rx.image)
      .disposed(by: disposeBag)
  }
}
