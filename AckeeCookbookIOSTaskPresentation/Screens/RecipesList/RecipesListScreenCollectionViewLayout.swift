//
//  RecipesListScreenCollectionViewLayout.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 17.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

final class RecipesListScreenCollectionViewLayout: UICollectionViewLayout {
    
    override init() {
        super.init()
        self.register(SeparatorView.self, forDecorationViewOfKind: decoratorIdentifier)
    }
    
    private let decoratorIdentifier: String = "tyu"
    private class SeparatorView: UICollectionReusableView {

        override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
            super.apply(layoutAttributes)
            backgroundColor = Colors.highlightGray
        }
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private var y = 0
    override func prepare() {
        super.prepare()
        y = 0
        prepareRecipesInList()
        prepareRecipesInListLoad()
    }
    
    private var recipesLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var recipesSeparatorsLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private func prepareRecipesInList() {
        recipesLayoutAttributes = []
        recipesSeparatorsLayoutAttributes = []
        guard let collectionView = collectionView else { return }
        let section = RecipesInListScreenController.recipesInListSection
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        guard numberOfItems > 0 else { return }
        let bounds = collectionView.bounds
        let boundsWidth = Int(bounds.width)
        let x = 24
        let width = boundsWidth - x * 2
        let spacing = 16
        y += spacing
        let height = 76
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: section)
            let recipeLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            recipeLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: height)
            recipesLayoutAttributes.append(recipeLayoutAttribute)
            y += height + spacing
            if item != numberOfItems - 1 {
                let recipeSeparatorLayoutAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: decoratorIdentifier, with: indexPath)
                recipeSeparatorLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: 1)
                recipesSeparatorsLayoutAttributes.append(recipeSeparatorLayoutAttribute)
                y += spacing
            }
        }
    }
    
    private var recipesInListLoadLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    private func prepareRecipesInListLoad() {
        recipesInListLoadLayoutAttributes = []
        guard let collectionView = collectionView else { return }
        let section = RecipesInListScreenController.recipesInListLoadSection
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let bounds = collectionView.bounds
        let boundsWidth = Int(bounds.width)
        if numberOfItems == 1 {
            let item = 0
            let x = 24
            let width = boundsWidth - x * 2
            let height = 76
            let indexPath = IndexPath(item: item, section: section)
            let recipesInListLoadLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            recipesInListLoadLayoutAttribute.frame = CGRect(x: x, y: y, width: width, height: height)
            y += height + 16
            recipesInListLoadLayoutAttributes.append(recipesInListLoadLayoutAttribute)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print(rect)
        let layoutAttributes = recipesLayoutAttributes + recipesSeparatorsLayoutAttributes + recipesInListLoadLayoutAttributes
        let layoutAttributesInRect = layoutAttributes.filter({ $0.frame.intersects(rect) })
        return layoutAttributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        let item = indexPath.item
        if section == RecipesInListScreenController.recipesInListSection {
            return recipesLayoutAttributes[item]
        }
        if section == RecipesInListScreenController.recipesInListLoadSection {
            return recipesInListLoadLayoutAttributes.first
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        if elementKind == decoratorIdentifier {
            return recipesSeparatorsLayoutAttributes[indexPath.item]
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let width = Int(collectionView.bounds.size.width)
        let height = y
        let size = CGSize(width: width, height: height)
        return size
    }
    
    // MARK: Updates
    
    private var deletedIndexPaths: [IndexPath] = []
    private var insertedIndexPaths: [IndexPath] = []
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        guard let collectionView = collectionView else { return }
        for updateItem in updateItems {
            let updateAction = updateItem.updateAction
            switch updateAction {
            case .insert:
                guard let indexPath = updateItem.indexPathAfterUpdate else { return }
                insertedIndexPaths.append(indexPath)
            case .delete:
                guard var indexPath = updateItem.indexPathBeforeUpdate else { return }
                let section = indexPath.section
                let item = indexPath.item
                if section == RecipesInListScreenController.recipesInListSection {
                    let numberOfItems = collectionView.numberOfItems(inSection: section)
                    if item == numberOfItems {
                        indexPath.item -= 1
                        deletedIndexPaths.append(indexPath)
                    } else {
                        deletedIndexPaths.append(indexPath)
                    }
                }
            default:
                break
            }
        }
    }

    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return deletedIndexPaths
    }

    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return insertedIndexPaths
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletedIndexPaths = []
        insertedIndexPaths = []
    }
    
}