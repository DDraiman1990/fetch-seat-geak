//
//  ZoomAndSnapFlowLayout.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/19/21.
//

import UIKit

class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {

    let activeDistance: CGFloat = 200
    var zoomFactor: CGFloat = 0

    override init() {
        super.init()

        scrollDirection = .horizontal
        minimumLineSpacing = 10
        collectionView?.decelerationRate = .fast
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            fatalError()
        }
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)

        super.prepare()
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let rectBounds = self.collectionView?.bounds else {
            return .zero
        }
        
        let halfWidth = rectBounds.size.width * CGFloat(0.50)
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        guard let proposedRect = self.collectionView?.bounds,
              let attributesArray = self.layoutAttributesForElements(in: proposedRect) else {
            return .zero
        }
        var candidateAttributes: UICollectionViewLayoutAttributes?
        for layoutAttributes : AnyObject in attributesArray {
            if let _layoutAttributes = layoutAttributes as? UICollectionViewLayoutAttributes {
                if _layoutAttributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                    continue
                }
                if candidateAttributes == nil {
                    candidateAttributes = _layoutAttributes
                    continue
                }
                if let atts = candidateAttributes, fabsf(Float(_layoutAttributes.center.x) - Float(proposedContentOffsetCenterX)) < fabsf(Float(atts.center.x) - Float(proposedContentOffsetCenterX)) {
                    candidateAttributes = _layoutAttributes
                }
            }
        }
        
        if attributesArray.count == 0 {
            return CGPoint(
                x: proposedContentOffset.x - halfWidth * 2,
                y: proposedContentOffset.y)
        }
        guard let atts = candidateAttributes else {
            return .zero
        }
        return CGPoint(
            x: atts.center.x - halfWidth,
            y: proposedContentOffset.y)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        guard let layoutAtts = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let rectAttributes = layoutAtts.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        // Make the cells be zoomed when they reach the center of the screen
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(1, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return rectAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext else {
            return .init()
        }
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}
