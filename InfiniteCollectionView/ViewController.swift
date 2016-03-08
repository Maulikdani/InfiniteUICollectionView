//
//  ViewController.swift
//  InfiniteCollectionView
//
//  Created by Arun Kumar.P on 3/8/16.
//  Copyright © 2016 ArunKumar.P. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var verticalDataSource = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var numberOfCells = 10
    var loadingStatus = LoadMoreStatus.haveMore
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Rotation methods

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            text="Portrait"
        case .PortraitUpsideDown:
            text="PortraitUpsideDown"
        case .LandscapeLeft:
            text="LandscapeLeft"
        case .LandscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
        collectionView.reloadData()

    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfCells
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        if(indexPath.row==numberOfCells-1){
            if loadingStatus == .haveMore {
                self.performSelector("loadMore", withObject: nil, afterDelay: 0)
            }
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.kVerticalCellIdentifier, forIndexPath: indexPath) as! VerticalCollectionViewCell
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
        
        return (loadingStatus == .Finished) ? CGSizeZero : CGSize(width: self.view.frame.width, height: 150)

    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
       
        return CGSize(width: self.view.frame.width, height: 150)
        
    }
    
}

