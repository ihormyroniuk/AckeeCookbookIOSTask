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
        delegate?.recipesListScreenGetList(offset: recipesListOffset, limit: recipesListLimit)
    }

    private func loadList() {
        delegate?.recipesListScreenGetList(offset: recipesListOffset, limit: recipesListLimit)
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
        cell.scoreProgressView.setScore(recipe.score)
        cell.durationLabel.text = "\(recipe.duration) min."
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

}
