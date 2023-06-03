//
//  File.swift
//  
//
//  Created by Paul on 02/06/2023.
//

import UIKit

protocol ScalingFlowLayoutProtocol {
    
    /// This method must be called from within viewDidLayoutSubviews() or layoutSubviews() to avoid  item sizes not being set
    func setItemSize(itemSize: CGSize)
    
    /**
     func getItemSize() -> CGSize {
         
         let myHeight = min(342,(self.bounds.height) - 40)
         let myWidth = floor((self.bounds.width) * 0.55)
         let desiredHeight = floor(myHeight)
         return CGSize(width: myWidth, height: desiredHeight)
     }
     */
}

public class ScalingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var lastCollectionViewSize: CGSize = .zero
        
    var scaleOffset: CGFloat = 200
    var scaleFactor: CGFloat = 0.85
    var alphaFactor: CGFloat = 0.3
    var lineSpacing: CGFloat = 5
    var horizontalInsets: CGFloat = 16
    
   public override init() {
        super.init()
        
        self.scrollDirection = .horizontal
        minimumLineSpacing = lineSpacing
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setItemSize(itemSize: CGSize) {
        self.itemSize = itemSize
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        guard let collectionView = self.collectionView else { return }
        
        if collectionView.bounds.size != lastCollectionViewSize {
            configureContentInset()
            lastCollectionViewSize = collectionView.bounds.size
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    ///Retreives the point at which to stop scrolling
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else { return proposedContentOffset }
        
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        guard let layoutAttributes = self.layoutAttributesForElements(in: proposedRect) else
        { return proposedContentOffset }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2
        
        for attributes in layoutAttributes {
            
            if attributes.representedElementCategory != .cell { continue }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if abs(attributes.center.x - proposedContentOffsetCenterX) <
                abs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        guard let candidateAttributes = candidateAttributes else {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes.center.x - collectionView.bounds.size.width / 2
        
        let offset = newOffsetX - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            
            let pageWidth = itemSize.width + minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }
    
    
    
    ///Retreives the layout attributes for all the cells and views in a rectangle then changes them accordingly
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let collectionView = self.collectionView,
              let superAttributes = super.layoutAttributesForElements(in: rect) else { return super.layoutAttributesForElements(in: rect)
        }

        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size

        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)

        let visibleCenterX = visibleRect.midX

        guard case let newAttributesArray as [UICollectionViewLayoutAttributes] = NSArray(array: superAttributes, copyItems: true) else { return nil }
        
        newAttributesArray.forEach { layoutAttrs in

            let distanceFromCenter = visibleCenterX - layoutAttrs.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scaleOffset)

            let scale = absDistanceFromCenter * (self.scaleFactor - 1) / self.scaleOffset + 1

            layoutAttrs.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)

            _ = (absDistanceFromCenter - 48) * (self.alphaFactor - 1) / self.scaleOffset + 1

            layoutAttrs.alpha = 1
        }

        return newAttributesArray
    }
}

//MARK: - METHODS

extension ScalingCollectionViewFlowLayout {
    
    func configureContentInset() {
        
        guard let collectionView = self.collectionView else { return }
        
        let layoutMargins: CGFloat = collectionView.layoutMargins.left + collectionView.layoutMargins.right
        
        let sideInset = collectionView.frame.width / 4.5 - layoutMargins
        
        collectionView.contentInset = UIEdgeInsets(top: 0,
        left: sideInset, bottom: 0, right: sideInset)
    }
    
    public func resetContentInset() {
        
        guard let collectionView = self.collectionView else { return }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
