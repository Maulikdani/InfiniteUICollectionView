//
//  VerticalCollectionViewCell.swift
//  InfiniteCollectionView
//
//  Created by Arun Kumar.P on 3/8/16.
//  Copyright © 2016 ArunKumar.P. All rights reserved.
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!

    var numberOfCells = 10
    var loadingStatus = LoadMoreStatus.haveMore

    func reloadData(){
        numberOfCells = 10
        collectionView.reloadData()
        if numberOfCells > 0 {
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Left, animated: true)
        }
    }

    func loadMore() {
        
        if numberOfCells >= 25{
            loadingStatus = .Finished
            collectionView.reloadData()
            return
        }
        
        // Replace code with web service and append to data source
        
        NSTimer.schedule(delay: 2) { timer in
            self.numberOfCells += 5
            self.collectionView.reloadData()
        }
    }

}

extension VerticalCollectionViewCell: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.kHorizontallCellIdentifier, forIndexPath: indexPath) as! HorizontalCollectionViewCell
        cell.label.text = "\(indexPath.row)"
        
        if(indexPath.row==numberOfCells-1){
            if loadingStatus == .haveMore {
                self.performSelector("loadMore", withObject: nil, afterDelay: 0)
            }
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var footerView:LoadMoreCollectionReusableView!
        
        if (kind ==  UICollectionElementKindSectionFooter) && (loadingStatus != .Finished){
            footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.kLoadMoreVerticalCollectionFooterViewCellIdentifier, forIndexPath: indexPath) as! LoadMoreCollectionReusableView
            
        }
        return footerView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (loadingStatus == .Finished) ? CGSizeZero : CGSizeMake(self.frame.height, self.frame.height)
    }
    
}

extension VerticalCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.frame.height, height: self.frame.height)
    }
    
}