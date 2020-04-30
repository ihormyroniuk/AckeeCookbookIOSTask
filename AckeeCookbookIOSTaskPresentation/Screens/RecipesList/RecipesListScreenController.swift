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

class RecipesListScreenController: AUIDefaultScreenController, RecipesListScreen, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: RecipesListScreen

    weak var delegate: RecipesListScreenDelegate?

    func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt) {
        guard recipesListOffset == offset else { return }
        recipesListOffset += limit
        if offset == 0 {
            recipesList = []
            recipesListScreenView.collectionViewRefreshControl.endRefreshing()
            recipesList.append(contentsOf: list)
            recipesListScreenView.collectionView.reloadData()
            recipesListScreenView.collectionView.contentOffset = .zero
        } else {
            recipesList.append(contentsOf: list)
            var insertIndexPathes: [IndexPath] = []
            for item in Int(offset)..<(Int(offset) + list.count) {
                let indexPath = IndexPath(item: item, section: 0)
                insertIndexPathes.append(indexPath)
            }
            recipesListScreenView.collectionView.performBatchUpdates({
                recipesListScreenView.collectionView.insertItems(at: insertIndexPathes)
            }, completion: nil)
        }
    }

    func knowRecipeCreated(_ recipe: RecipeInDetails) {
        refreshList()
    }
    
    func deleteRecipe(_ recipe: RecipeInList) {
        let id = recipe.id
        guard let item = recipesList.firstIndex(where: { $0.id == id }) else { return }
        recipesList.remove(at: item)
        recipesListOffset -= 1
        let indexPath = IndexPath(item: item, section: 0)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
    func changeRecipeScore(_ recipe: RecipeInList, score: Float) {
        let recipeId = recipe.id
        guard let index = recipesList.firstIndex(where: { $0.id == recipeId }) else { return }
        recipesList[index].score = score
        let indexPath = IndexPath(item: index, section: 0)
        recipesListScreenView.collectionView.performBatchUpdates({
            self.recipesListScreenView.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }

    // MARK: Data

    private var recipesListOffset: UInt = 0
    private let recipesListLimit: UInt = 20
    private var recipesList: [RecipeInList] = []

    // MARK: Localization

    private let localizer: ALocalizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "RecipesListScreenStrins"
        let textLocalizer = ATableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = ACompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()

    // MARK: RecipesListScreenView

    private var recipesListScreenView: RecipesListScreenView! {
        return view as? RecipesListScreenView
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
        recipesListScreenView.collectionViewRefreshControl.addTarget(self, action: #selector(refreshRecipesList), for: .valueChanged)
    }

    // MARK: Events

    private var isFirstViewWillAppear = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstViewWillAppear {
            refreshList()
        }
        isFirstViewWillAppear = false
    }

    // MARK: Actions

    private func refreshList() {
        recipesListOffset = 0
        recipesListScreenView.collectionViewRefreshControl.beginRefreshing()
        delegate?.recipesListScreenGetList(self, offset: recipesListOffset, limit: recipesListLimit)
    }

    private func loadList() {
        delegate?.recipesListScreenGetList(self, offset: recipesListOffset, limit: recipesListLimit)
    }

    @objc private func addReceipe() {
        delegate?.recipesListScreenAddRecipe(self)
    }

    @objc private func refreshRecipesList() {
        refreshList()
    }

    // MARK: Content

    private func setContent() {
        recipesListScreenView.titleLabel.text = localizer.localizeText("title")
    }

    // MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recipe = recipesList[indexPath.item]
        let cell: RecipeListItemCollectionViewCell = recipesListScreenView.recipeListItemViewCollectionViewCell(indexPath)
        cell.nameLabel.text = recipe.name
        cell.scoreView.setScore(recipe.score)
        cell.durationLabel.text = localizer.localizeText("durationInMinutes", "\(recipe.duration)")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = recipesListScreenView.recipeListItemViewCollectionViewCellSize(indexPath)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if Int(recipesListOffset) - Int(recipesListLimit) == indexPath.item {
            loadList()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipesList[indexPath.item]
        delegate?.recipesListScreenShowRecipeInDetails(self, recipeInList: recipe)
    }

}
