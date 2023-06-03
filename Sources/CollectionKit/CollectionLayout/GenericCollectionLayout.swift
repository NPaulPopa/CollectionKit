//
//  File.swift
//  
//
//  Created by Paul on 22/05/2023.
//

import UIKit

public class GenericCollectionLayout {

    //MARK: - Cell Layout
    
    public init() { }
    
    public enum CellLayout {
        
        case flow(cellSize: CGSize, spacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection = .horizontal)
        
        case compositional(groupWidth: CGFloat,groupHeight: CGFloat,spacing: CGFloat? = nil,scrollDirection: UICollectionLayoutSectionOrthogonalScrollingBehavior)
    }
    
    public func setupLayout(_ layout: CellLayout?) -> UICollectionViewLayout? {
        
        guard let layout = layout else {
            return nil
        }

        switch layout {
            
        case .flow(let cellSize, let spacing, let scrollDirection):
            
        return setupFlowLayout(interitemSpacing: spacing, itemSize: cellSize, scrollDirection: scrollDirection)
                    
        case .compositional(let groupWidth, let groupHeight, let spacing, let scrollDirection):
            
        return setupCompositionalLayout(groupWidth: groupWidth, groupHeight: groupHeight,spacing: spacing, scrollDirection: scrollDirection)
        }
    }
    
    //MARK: - Flow Layout
    
    private func setupFlowLayout(interitemSpacing: CGFloat, itemSize: CGSize, scrollDirection: UICollectionView.ScrollDirection) -> UICollectionViewLayout {
        
        let layout = AnimatableFlowLayout() //UICollectionViewFlowLayout() //
       
        /*
         layout.minimumLineSpacing = interitemSpacing
        //layout.minimumInteritemSpacing = interitemSpacing
        layout.itemSize = itemSize
        layout.scrollDirection = scrollDirection
         */
        
        layout.minimumInteritemSpacing = interitemSpacing
        layout.itemSize = itemSize
        layout.scrollDirection = scrollDirection
        
        return layout
    }
    
    //MARK: - Compositional Layout

    private func setupCompositionalLayout(groupWidth: CGFloat, groupHeight: CGFloat,spacing: CGFloat? = nil, scrollDirection: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> UICollectionViewLayout {
                
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))

                let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
                if let spacing = spacing {
                    
                    let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: spacing)
                
                    item.contentInsets = contentInsets
                }

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(groupWidth),
                    heightDimension: .estimated(groupHeight))

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
 
                let section = NSCollectionLayoutSection(group: group)

                section.orthogonalScrollingBehavior = scrollDirection

                return section
        })
        
        return layout
    }
}

//MARK: AnimatableFlowLayout

class AnimatableFlowLayout: UICollectionViewFlowLayout {
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        UIView.animate(withDuration: 0.7, delay: 0) {
            attributes?.alpha = 0
        }
               
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        UIView.animate(withDuration: 0.7, delay: 0) {
            attributes?.alpha = 1
        }
        
        return attributes
    }
}
