//
//  RecipesListScreenView.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class RecipesInListScreenView: ScreenViewWithNavigationBar {

    // MARK: Elements

    let titleLabel = UILabel()
    let addRecipeButton = AlphaHighlightButton()
    let collectionViewLayout = FeedCollectionViewFlowLayout()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        return collectionView
    }()
    let refreshControl = UIRefreshControl()

    // MARK: Setup

    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(collectionView)
        setupCollectionView()
    }

    override func setupStatusBarView() {
        super.setupStatusBarView()
        statusBarView.backgroundColor = .white
    }

    override func setupNavigationBarView() {
        super.setupNavigationBarView()
        navigationBarView.backgroundColor = .white
        navigationBarView.addSubview(titleLabel)
        setupTitleLabel()
        navigationBarView.addSubview(addRecipeButton)
        setupAddRecipeButton()
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
    }

    private func setupAddRecipeButton() {
        let image = Images.plusInCircle
        addRecipeButton.setImage(image.withTintColor(Colors.blue), for: .normal)
        addRecipeButton.setImage(image.withTintColor(Colors.blue), for: .highlighted)
    }

    private let recipeListItemViewCollectionViewCellIdentifier = "recipeListItemViewCollectionViewCellIdentifier"
    private let recipesInListScreenLoadCollectionViewCellIdentifier = "RecipesInListScreenLoadCollectionViewCellIdentifier"
    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.backgroundColor = .white
        collectionView.register(RecipesInListScreenRecipeCollectionViewCell.self, forCellWithReuseIdentifier: recipeListItemViewCollectionViewCellIdentifier)
        collectionView.register(RecipesInListScreenLoadCollectionViewCell.self, forCellWithReuseIdentifier: recipesInListScreenLoadCollectionViewCellIdentifier)
        collectionView.addSubview(refreshControl)
    }

    // Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutAddRecipeButton()
        layoutTitleLabel()
        layoutCollectionView()
    }

    private func layoutAddRecipeButton() {
        let width: CGFloat = 32
        let height: CGFloat = 32
        let x: CGFloat = navigationBarView.bounds.width - 8 - width
        let y: CGFloat = (navigationBarView.bounds.height - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        addRecipeButton.frame = frame
    }

    private func layoutTitleLabel() {
        let possibleWidth: CGFloat = navigationBarView.bounds.width - 2 * (navigationBarView.bounds.width - addRecipeButton.frame.origin.x + 8)
        let possibleHeight: CGFloat = navigationBarView.bounds.height
        let possibleSize = CGSize(width: possibleWidth, height: possibleHeight)
        var size = titleLabel.sizeThatFits(possibleSize)
        if size.height > possibleHeight {
            size.height = possibleHeight
        }
        let x: CGFloat = (navigationBarView.bounds.width - size.width) / 2
        let y: CGFloat = (navigationBarView.bounds.height - size.height) / 2
        let origin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: origin, size: size)
        titleLabel.frame = frame
    }

    private func layoutCollectionView() {
        let x: CGFloat = 0
        let y = navigationBarView.frame.origin.y + navigationBarView.frame.height
        let width = bounds.size.width
        let height = bounds.height - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        collectionView.frame = frame
    }

    // MARK: Cells

    func recipeListItemViewCollectionViewCell(_ indexPath: IndexPath) -> RecipesInListScreenRecipeCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeListItemViewCollectionViewCellIdentifier, for: indexPath) as? RecipesInListScreenRecipeCollectionViewCell
        return cell
    }
    
    func recipesInListScreenLoadCollectionViewCell(_ indexPath: IndexPath) -> RecipesInListScreenLoadCollectionViewCell! {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipesInListScreenLoadCollectionViewCellIdentifier, for: indexPath) as? RecipesInListScreenLoadCollectionViewCell
        return cell
    }

}

final class FeedCollectionViewFlowLayout: UICollectionViewLayout {
    
    override init() {
        super.init()
        self.register(FeedSeparatorView.self, forDecorationViewOfKind: decoratorIdentifier)
    }
    
    private let decoratorIdentifier: String = "tyu"
    private class FeedSeparatorView: UICollectionReusableView {

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
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletedIndexPaths = []
        insertedIndexPaths = []
    }
    
}
