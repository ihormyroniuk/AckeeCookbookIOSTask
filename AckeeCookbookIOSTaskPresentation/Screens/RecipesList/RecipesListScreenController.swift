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

    func takeRecipesList(_ list: [Recipe], offset: UInt, limit: UInt) {
        
    }

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

    // MARK: Actions

    @objc private func addReceipe() {
        delegate?.recipesListScreenAddRecepe(self)
    }

    @objc private func refreshRecipesList() {

    }

    // MARK: Content

    private func setContent() {
        recipesListScreenView.titleLabel.text = localizer.localizeText("title")
    }

    // MARK: Ssfdsf

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecipeListItemCollectionViewCell = recipesListScreenView.recipeListItemViewCollectionViewCell(indexPath)
        cell.nameLabel.text = "sdfdsfdsfsdf sdf dfsd sdf"
        cell.scoreProgressView.setValue(0.5)
        cell.durationLabel.text = "10 min."
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = recipesListScreenView.recipeListItemViewCollectionViewCellSize(indexPath)
        return size
    }

}
