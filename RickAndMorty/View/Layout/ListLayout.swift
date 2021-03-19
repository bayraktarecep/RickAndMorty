//
//  ListLayout.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import Foundation
import UIKit

//MARK: List Layout for CollectionView
class ListLayout: UICollectionViewFlowLayout {
    
    let cellHeight: CGFloat = 370
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
        
    }
    
    var cellWidth: CGFloat {
        
        return collectionView!.frame.width
    }
    
    //MARK: This section is create new item for the list view
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        }
        get {
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
