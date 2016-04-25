//
//  CardCell.swift
//  SnapCard
//
//  Created by Qin Yejun on 4/25/16.
//  Copyright © 2016 Qinyejun. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
  @IBOutlet private weak var headerView:UIView!
  @IBOutlet private weak var titleLabel:UILabel!
  @IBOutlet private weak var contentLabel:UILabel!
  
  static let gradientRows = 8
  
  //private let hue:CGFloat = 20.0
  private let minSaturation:CGFloat = 0.64
  private let maxSaturation:CGFloat = 1.0
  private var deltaSaturation:CGFloat {
    return maxSaturation - minSaturation
  }
  private let minHue:CGFloat = 20.0
  private let maxHue:CGFloat = 50.0
  private var deltaHue:CGFloat {
    return maxHue - minHue
  }
  
  static func reuseIdentifier() -> String {
    return "CardCell"
  }
  
  func configCellWithTitle(title:String, content:String) {
    titleLabel.text = title
    contentLabel.text = content
  }
  
  /* Returns the item index of the currently featured cell */
  var featuredItemIndex: Int {
    if let collectionView = self.superview as? UICollectionView {
      let layout = collectionView.collectionViewLayout as! CardListLayout
      return layout.featuredItemIndex
    }
    return 0
  }
  
  /* Returns the item Cell of the currently featured cell */
  var featuredItem: CardCell? {
    if let collectionView = self.superview as? UICollectionView {
      return collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: featuredItemIndex, inSection: 0)) as? CardCell
    }
    return nil
  }
  
  /* Returns the item Cell below the currently featured cell */
  var nextItem: CardCell? {
    if let collectionView = self.superview as? UICollectionView {
      return collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: featuredItemIndex + 1, inSection: 0)) as? CardCell
    }
    return nil
  }
  
  /* Returns the indexPath of the cell */
  var indexPath: NSIndexPath {
    if let collectionView = self.superview as? UICollectionView,
      let indexPath = collectionView.indexPathForCell(self){
      return indexPath
    }
    return NSIndexPath(forRow: 0, inSection: 0)
  }
  
  /* Returns the color saturation of current cell header */
  var currentSaturation: CGFloat {
    let rows = self.dynamicType.gradientRows
    let delta = CGFloat(min(max(indexPath.row - featuredItemIndex, 0), rows)) / CGFloat(rows)
    return min(minSaturation + delta * deltaSaturation, maxSaturation)
  }
  
  /* Returns the color saturation the cell header will become */
  var nextSaturation: CGFloat {
    let rows = self.dynamicType.gradientRows
    let delta = CGFloat(min(max(indexPath.row - featuredItemIndex - 1, 0), rows)) / CGFloat(rows)
    return min(minSaturation + delta * deltaSaturation, maxSaturation)
  }
  
  /* Returns the color hue of current cell header */
  var currentHue: CGFloat {
    let rows = self.dynamicType.gradientRows
    let delta = CGFloat(min(max(indexPath.row - featuredItemIndex, 0), rows)) / CGFloat(rows)
    return min(minHue + delta * deltaHue, maxHue)
  }

  /* Returns the color saturation the cell header will become */
  var nextHue: CGFloat {
    let rows = self.dynamicType.gradientRows
    let delta = CGFloat(min(max(indexPath.row - featuredItemIndex - 1, 0), rows)) / CGFloat(rows)
    return min(minHue + delta * deltaHue, maxHue)
  }
  
  /* Returns the color of current cell */
  private func currentColorForIndexPath(indexPath:NSIndexPath) -> UIColor {
    let rows = self.dynamicType.gradientRows
    let delta = CGFloat(min(max(indexPath.row - featuredItemIndex, 0), rows)) / CGFloat(rows)
    //return UIColor(hue: hue/360.0, saturation:min(minSaturation + delta * deltaSaturation, maxSaturation), brightness: 1.0, alpha: 1.0)
    return UIColor(hue: min(minHue + delta * deltaHue, maxHue)/360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    super.applyLayoutAttributes(layoutAttributes)
    
    let featuredHeight = CardListLayoutConstants.Cell.featuredHeight
    let standardHeight = CardListLayoutConstants.Cell.standardHeight
    
    let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
    
    contentLabel.alpha = delta
    
    var nextItemHeight:CGFloat = CGRectGetHeight(frame)
    if let item = nextItem {
      nextItemHeight = CGRectGetHeight(item.frame)
    }
    let deltaSaturation = fabs(nextSaturation - currentSaturation)
    let deltaColor = 1 - ((featuredHeight - nextItemHeight) / (featuredHeight - standardHeight))
    
    //headerView.backgroundColor = UIColor(hue: hue/360.0, saturation: currentSaturation - deltaColor * deltaSaturation, brightness: 1.0, alpha: 1.0)
    headerView.backgroundColor = UIColor(hue: (currentHue - deltaColor * fabs(nextHue - currentHue))/360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    
  }
  
  func setCurrentColorForIndexPath(indexPath:NSIndexPath) {
    headerView.backgroundColor = currentColorForIndexPath(indexPath)
  }
}
