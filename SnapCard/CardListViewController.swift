//
//  CardListViewController.swift
//  SnapCard
//
//  Created by Qin Yejun on 4/25/16.
//  Copyright © 2016 Qinyejun. All rights reserved.
//

import UIKit

class CardListViewController: UICollectionViewController {
  
  lazy var data:[[String:String]] = {
    var myDict: NSDictionary?
    if let path = NSBundle.mainBundle().pathForResource("data", ofType: "plist") {
      myDict = NSDictionary(contentsOfFile: path)
    }
    if let dict = myDict?["data"] as? [[String:String]] {
      return dict
    } else {
      return [[String:String]]()
    }
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    self.title = "Snap Card"
    
    collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CardCell.reuseIdentifier(), forIndexPath: indexPath) as! CardCell
    
    let item = data[indexPath.row]
    cell.configCellWithTitle(item["title"]!, content: item["content"]!)
    cell.setCurrentColorForIndexPath(indexPath)
    
    return cell
  }
  
  
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard let layout = collectionView.collectionViewLayout as? CardListLayout else {
      return
    }
    let y = CGFloat(indexPath.item) * layout.dragOffset
    collectionView.scrollRectToVisible(CGRectMake(0, y, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), animated: true)
  }
}
