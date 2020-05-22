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

protocol RecipesDetailsScreenDelegate: class {
    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeDetailsScreenController)
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInList: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails)
    func recipeInDetailsScreenUpdateRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails)
    func recipeInDetailsScreenSetScore(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipe: RecipeInDetails, score: Float)
}

class RecipeDetailsScreenController: AUIDefaultScreenController {
    
    // MARK: RecipeInDetailsScreen
    
    var delegate: RecipesDetailsScreenDelegate?
    
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
        let tableName = "RecipeDetailsScreenStrings"
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
        recipeInDetailsScreenView.updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        recipeInDetailsScreenView.scrollViewRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        for button in recipeInDetailsScreenView.setScoreButtons {
            button.addTarget(self, action: #selector(setScore), for: .touchUpInside)
        }
        statusBarStyle = .lightContent
        setContent()
    }
    
    // MARK: AddRecipeScreenView

    private var recipeInDetailsScreenView: RecipeDetailsScreenView! {
        return view as? RecipeDetailsScreenView
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
        //delegate?.recipeInDetailsScreenUpdateRecipeInDetails(self, recipeInDetails: recipeInDetails)
        delegate?.recipeInDetailsScreenDeleteRecipeInDetails(self, recipeInDetails: recipeInDetails)
    }
    
    @objc private func update() {
        guard let recipeInDetails = recipeInDetails else { return }
        delegate?.recipeInDetailsScreenUpdateRecipeInDetails(self, recipeInDetails: recipeInDetails)
    }
    
    @objc private func refresh() {
        delegate?.recipeInDetailsScreenGetRecipeInDetails(self, recipeInList: recipeInList, completionHandler: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let recipe):
                self.recipeInDetails = recipe
                self.setRecipeInDetailsContent(recipe)
                self.recipeInDetailsScreenView.setNeedsLayout()
                self.recipeInDetailsScreenView.layoutIfNeeded()
                self.recipeInDetailsScreenView.scrollViewRefreshControl.endRefreshing()
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    private func loadDetails() {
        if recipeInDetails == nil {
            recipeInDetailsScreenView.scrollViewRefreshControl.beginRefreshing()
            refresh()
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
        recipeInDetailsScreenView.updateButton.setTitle(localizer.localizeText("update"), for: .normal)
        recipeInDetailsScreenView.setScoreLabel.text = localizer.localizeText("score")
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
