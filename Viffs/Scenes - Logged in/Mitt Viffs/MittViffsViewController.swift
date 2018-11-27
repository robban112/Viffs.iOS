//
//  MittViffsViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Overture
import RxDataSources

class MittViffsViewController: ViffsViewController, ViewModelBindable {
  typealias ReceiptCollectionDataSource =
    RxCollectionViewSectionedReloadDataSource<SectionModel<Int, ReceiptCollection>>

  let dataSource = ReceiptCollectionDataSource(configureCell: { (_, cv, ip, coll) in
    let cell = cv.dequeueReusableCell(type: MittViffsCell.self, forIndexPath: ip)
    cell.collection = coll
    return cell
  })

  let disposeBag = DisposeBag()

  var viewModel: MittViffsViewModelType!

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var hamburgerButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.registerCell(type: MittViffsCell.self)
  }

  func bindViewModel() {
    bindUIToViewModel()
    bindViewModelToUI()
  }

  func bindUIToViewModel() {
    collectionView.rx.modelSelected(ReceiptCollection.self)
      .bind(to: viewModel.inputs.receiptCollectionSelected)
      .disposed(by: disposeBag)
  }

  func bindViewModelToUI() {
    viewModel.outputs.receiptCollectionsContents
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
