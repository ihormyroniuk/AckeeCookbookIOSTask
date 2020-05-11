//
//  RecipesListScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation
import AckeeCookbookIOSTaskBusiness

class RecipesInListScreenController: AUIDefaultScreenController, RecipesInListScreen, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: RecipesListScreen

    weak var delegate: RecipesInListScreenDelegate?

    func takeRecipesInList(_ recipes: [RecipeInList], offset: UInt, limit: UInt) {
        guard recipesInListLoadOffset == offset else { return }
        recipesInListLoadOffset += limit
        var insertedIndexPaths: [IndexPath] = []
        for item in Int(offset)..<(Int(offset) + recipes.count) {
            let indexPath = IndexPath(item: item, section: RecipesInListScreenController.recipesInListSection)
            insertedIndexPaths.append(indexPath)
        }
        var deletedIndexPaths: [IndexPath] = []
        if offset == 0 {
            let section = RecipesInListScreenController.recipesInListSection
            for item in 0..<recipesInList.count {
                let indexPath = IndexPath(item: item, section: section)
                deletedIndexPaths.append(indexPath)
            }
            recipesInList = recipes
            recipesListScreenView.collectionView.contentOffset = .zero
            recipesListScreenView.refreshControl.endRefreshing()
            recipesListScreenView.collectionView.performBatchUpdates({
                recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
                recipesListScreenView.collectionView.insertItems(at: insertedIndexPaths)
            }, completion: nil)
        } else {
            let item = 0
            let indexPath = IndexPath(item: item, section: RecipesInListScreenController.recipesInListLoadSection)
            deletedIndexPaths.append(indexPath)
            recipesInListLoad = false
            recipesInList.append(contentsOf: recipes)
            recipesListScreenView.collectionView.performBatchUpdates({
                recipesListScreenView.collectionView.deleteItems(at: deletedIndexPaths)
                recipesListScreenView.collectionView.insertItems(at: insertedIndexPaths)
            }, completion: nil)
        }
    }
    
    func takeErrorGetRecipesInList(_ error: Error, offset: UInt, limit: UInt) {
        
    }

    func knowRecipeWasAdded(_ recipe: RecipeInList) {
        refreshList()
    }
    
    func knowRecipeWasDeleted(_ recipe: RecipeInList) {
        let id = recipe.id
        guard let item = recipesInList.firstIndex(where: { $0.id == id }) else { return }
        let section = RecipesInListScreenController.recipesInListSection
        recipesInList.remove(at: item)
        recipesInListLoadOffset -= 1
        let indexPath = IndexPath(item: item, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func knowRecipeScoreWasChanged(_ recipe: RecipeInList, score: Float) {
        let recipeId = recipe.id
        guard let item = recipesInList.firstIndex(where: { $0.id == recipeId }) else { return }
        let section = RecipesInListScreenController.recipesInListSection
        recipesInList[item].score = score
        let indexPath = IndexPath(item: item, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
    func knowRecipeWasUpdated(_ recipe: RecipeInList) {
        let recipeId = recipe.id
        guard let index = recipesInList.firstIndex(where: { $0.id == recipeId }) else { return }
        recipesInList[index] = recipe
        let section = RecipesInListScreenController.recipesInListSection
        let indexPath = IndexPath(item: index, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }

    // MARK: Data

    private var recipesInListLoadOffset: UInt = 0
    private let recipesInListLoadlimit: UInt = 10
    private var recipesInList: [RecipeInList] = []
    private var lastDisplayedRecipeInListIndex: Int?
    private var recipesInListLoad = false

    // MARK: Localization

    private let localizer: ALocalizer = {
        let bundle = Bundle(for: RecipesInListScreenController.self)
        let tableName = "RecipesInListScreenStrins"
        let textLocalizer = ATableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = ACompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()

    // MARK: RecipesListScreenView

    private var recipesListScreenView: RecipesInListScreenView! {
        return view as? RecipesInListScreenView
    }

    // MARK: Setup

    override func setup() {
        super.setup()
        recipesListScreenView.collectionView.dataSource = self
        recipesListScreenView.collectionView.delegate = self
        setupAddRecipeButton()
        setupCollectionViewRefreshControl()
        setContent()
    }

    private func setupAddRecipeButton() {
        recipesListScreenView.addRecipeButton.addTarget(self, action: #selector(addReceipe), for: .touchUpInside)
    }

    private func setupCollectionViewRefreshControl() {
        recipesListScreenView.refreshControl.addTarget(self, action: #selector(refreshRecipesList), for: .valueChanged)
    }

    // MARK: Events

    private var isFirstViewWillAppear = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstViewWillAppear {
            refreshList()
        }
        isFirstViewWillAppear = false
        if recipesListScreenView.refreshControl.isRefreshing {
            recipesListScreenView.refreshControl.beginRefreshing()
        }
    }

    // MARK: Actions

    private func refreshList() {
        lastDisplayedRecipeInListIndex = nil
        recipesInListLoadOffset = 0
        recipesListScreenView.refreshControl.beginRefreshing()
        delegate?.recipesInListScreenGetRecipes(self, offset: recipesInListLoadOffset, limit: 2 * recipesInListLoadlimit)
    }

    private func loadList() {
        recipesInListLoad = true
        let section = RecipesInListScreenController.recipesInListLoadSection
        let item = 0
        let indexPath = IndexPath(item: item, section: section)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.insertItems(at: [indexPath])
        }, completion: nil)
        delegate?.recipesInListScreenGetRecipes(self, offset: recipesInListLoadOffset, limit: recipesInListLoadlimit)
    }

    @objc private func addReceipe() {
        delegate?.recipesInListScreenAddRecipe(self)
    }

    @objc private func refreshRecipesList() {
        refreshList()
    }
    
    private func willDisplayRecipeInListAtIndex(_ index: Int) {
        if Int(recipesInListLoadOffset) - Int(recipesInListLoadlimit) == index {
            if let lastDisplayedRecipeInListIndex = lastDisplayedRecipeInListIndex {
                if index > lastDisplayedRecipeInListIndex {
                    loadList()
                    self.lastDisplayedRecipeInListIndex  = index
                }
            } else {
                loadList()
                lastDisplayedRecipeInListIndex  = index
            }
        }
    }

    // MARK: Content

    private func setContent() {
        recipesListScreenView.titleLabel.text = localizer.localizeText("title")
    }

    // MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

    static let recipesInListSection = 0
    static let recipesInListLoadSection = 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return [RecipesInListScreenController.recipesInListSection, RecipesInListScreenController.recipesInListLoadSection].count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case RecipesInListScreenController.recipesInListSection:
            return recipesInList.count
        case RecipesInListScreenController.recipesInListLoadSection:
            return recipesInListLoad ? 1 : 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let item = indexPath.item
        switch section {
        case RecipesInListScreenController.recipesInListSection:
            let recipe = recipesInList[item]
            let cell: RecipesInListScreenRecipeCollectionViewCell = recipesListScreenView.recipeListItemViewCollectionViewCell(indexPath)
            cell.nameLabel.text = recipe.name
            cell.scoreView.setScore(recipe.score)
            cell.durationLabel.text = localizer.localizeText("durationInMinutes", "\(recipe.duration)")
            return cell
        case RecipesInListScreenController.recipesInListLoadSection:
            let cell: RecipesInListScreenLoadCollectionViewCell = recipesListScreenView.recipesInListScreenLoadCollectionViewCell(indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        switch section {
        case RecipesInListScreenController.recipesInListSection:
            willDisplayRecipeInListAtIndex(item)
        default:
            break
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipesInList[indexPath.item]
        delegate?.recipesInListScreenShowRecipeInDetails(self, recipeInList: recipe)
    }

}
