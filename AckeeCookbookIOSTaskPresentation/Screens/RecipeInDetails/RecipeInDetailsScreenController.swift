//
//  RecipeInDetailsScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/6/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness
import AFoundation

class RecipeInDetailsScreenController: AUIDefaultScreenController, RecipeInDetailsScreen {
    
    // MARK: RecipeInDetailsScreen
    
    var delegate: RecipesInDetailsScreenDelegate?

    func takeRecipeInDetails(_ recipe: RecipeInDetails, recipeInList: RecipeInList) {
        guard recipeInList.id == recipe.id else { return }
        recipeInDetails = recipe
        setRecipeInDetailsContent(recipe)
        recipeInDetailsScreenView.setNeedsLayout()
        recipeInDetailsScreenView.layoutIfNeeded()
        recipeInDetailsScreenView.scrollViewRefreshControl.endRefreshing()
    }
    
    func changeRecipeScore(_ recipe: RecipeInDetails, score: Float) {
        guard recipeInList.id == recipe.id else { return }
        recipeInList.score = score
        recipeInDetails?.score = score
        recipeInDetailsScreenView.setScore(score)
    }
    
    func updateRecipe(_ recipe: RecipeInDetails) {
        guard recipeInList.id == recipe.id else { return }
        recipeInList = recipe
        setRecipeInDetailsContent(recipe)
        recipeInDetailsScreenView.setNeedsLayout()
        recipeInDetailsScreenView.layoutIfNeeded()
    }
    
    // MARK: Localization

    private let localizer: ALocalizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "RecipeInDetailsScreenStrings"
        let textLocalizer = ATableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = ACompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()
    
    // MARK: Data
    
    private var recipeInList: RecipeInList
    private var recipeInDetails: RecipeInDetails?
    
    init(view: UIView, recipeInList: RecipeInList) {
        self.recipeInList = recipeInList
        super.init(view: view)
        recipeInDetailsScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        recipeInDetailsScreenView.deleteButton.addTarget(self, action: #selector(delete2), for: .touchUpInside)
        recipeInDetailsScreenView.scrollViewRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        for button in recipeInDetailsScreenView.setScoreButtons {
            button.addTarget(self, action: #selector(setScore), for: .touchUpInside)
        }
        setContent()
    }
    
    // MARK: AddRecipeScreenView

    private var recipeInDetailsScreenView: RecipeInDetailsScreenView! {
        return view as? RecipeInDetailsScreenView
    }

    // MARK: Events
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDetails()
    }
    
    // MARK: Actions
    
    @objc private func back() {
        delegate?.recipeInDetailsScreenBack(self)
    }

    @objc private func delete2() {
        guard let recipeInDetails = recipeInDetails else { return }
        delegate?.recipeInDetailsScreenUpdateRecipeInDetails(self, recipeInDetails: recipeInDetails)
        //delegate?.recipeInDetailsScreenDeleteRecipeInDetails(self, recipeInDetails: recipeInDetails)
    }
    
    @objc private func refresh() {
        delegate?.recipeInDetailsScreenGetRecipeInDetails(self, recipeInList: recipeInList)
    }
    
    private func loadDetails() {
        if recipeInDetails == nil {
            recipeInDetailsScreenView.scrollViewRefreshControl.beginRefreshing()
            delegate?.recipeInDetailsScreenGetRecipeInDetails(self, recipeInList: recipeInList)
        }
    }
    
    @objc private func setScore(_ button: UIButton) {
        guard let index = recipeInDetailsScreenView.setScoreButtons.firstIndex(of: button) else { return }
        let score: Float = Float(index + 1)
        guard let recipe = self.recipeInDetails else { return }
        delegate?.recipeInDetailsScreenSetScore(self, recipe: recipe, score: score)
    }
    
    // MARK: Content

    private func setContent() {
        recipeInDetailsScreenView.backButton.setTitle(localizer.localizeText("back"), for: .normal)
        recipeInDetailsScreenView.deleteButton.setTitle(localizer.localizeText("delete"), for: .normal)
    }
    
    private func setRecipeInDetailsContent(_ recipe: RecipeInDetails) {
        recipeInDetailsScreenView.infoLabel.text = recipe.info
        recipeInDetailsScreenView.ingredientsLabel.text = localizer.localizeText("ingredients")
        recipeInDetailsScreenView.setIngredients(recipe.ingredients)
        recipeInDetailsScreenView.descriptionTitleLabel.text = localizer.localizeText("description")
        recipeInDetailsScreenView.descriptionLabel.text = recipe.description
        recipeInDetailsScreenView.setScore(recipe.score)
        recipeInDetailsScreenView.setDuration(localizer.localizeText("durationInMinutes", "\(recipe.duration)"))
    }
}
