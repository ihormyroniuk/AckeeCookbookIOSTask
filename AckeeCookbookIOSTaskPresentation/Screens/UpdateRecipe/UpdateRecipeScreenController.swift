//
//  UpdateRecipeScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 03.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation
import AckeeCookbookIOSTaskBusiness

class UpdateRecipeScreenController: AUIDefaultScreenController, UpdateRecipeScreen, AUITextViewControllerDidChangeTextObserver, AUIControlControllerDidValueChangedObserver {
    
    private var recipe: RecipeInDetails
    
    init(view: UIView, recipe: RecipeInDetails) {
        self.recipe = recipe
        super.init(view: view)
    }

    // MARK: AddRecipeScreen

    weak var delegate: UpdateRecipeScreenDelegate?

    // MARK: Localization

    private let localizer: ALocalizer = {
        let bundle = Bundle(for: RecipesListScreenController.self)
        let tableName = "AddRecipeScreenStrings"
        let textLocalizer = ATableNameBundleTextLocalizer(tableName: tableName, bundle: bundle)
        let localizator = ACompositeLocalizer(textLocalization: textLocalizer)
        return localizator
    }()

    // MARK: AddRecipeScreenView

    private var addRecipeScreenView: AddRecipeScreenView! {
        return view as? AddRecipeScreenView
    }

    // MARL: Controllers

    private let nameTextViewController = AUIEmptyTextViewController()
    private let infoTextViewController = AUIEmptyTextViewController()
    private var ingredientInputViewControllers: [AUIResponsiveTextViewTextInputViewController] = []
    private let descriptionTextViewController = AUIEmptyTextViewController()
    private let durationTextViewController = AUIEmptyTextFieldController()
    private let durationDatePickerControler = AUIDefaultDatePickerController()

    // MARK: Setup

    override func setup() {
        super.setup()
        addRecipeScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        addRecipeScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        nameTextViewController.textView = addRecipeScreenView.nameTextInputView.textView
        nameTextViewController.addDidChangeTextObserver(self)
        infoTextViewController.textView = addRecipeScreenView.infoTextInputView.textView
        infoTextViewController.addDidChangeTextObserver(self)
        descriptionTextViewController.textView = addRecipeScreenView.descriptionInputView.textView
        descriptionTextViewController.addDidChangeTextObserver(self)
        addRecipeScreenView.addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        durationTextViewController.textField = addRecipeScreenView.durationInputView.textField
        durationTextViewController.inputViewController = durationDatePickerControler
        durationDatePickerControler.countDownDuration = 50
        durationDatePickerControler.minuteInterval = 10
        durationDatePickerControler.mode = .countDownTimer
        durationDatePickerControler.addDidValueChangedObserver(self)
        setContent()
    }

    // MARK: Events

    func textViewControllerDidChangeText(_ textViewController: AUITextViewController) {
        addRecipeScreenView.setNeedsLayout()
        addRecipeScreenView.layoutIfNeeded()
    }
    
    func controlControllerDidValueChanged(_ controlController: AUIControlController) {
        if controlController === durationDatePickerControler {
            pickDuration()
        }
    }

    // MARK: Actions

    @objc private func back() {
        delegate?.updateRecipeScreenBack(self)
    }

    @objc private func add() {
        guard let name = nameTextViewController.text else {
            return
        }
        guard let description = descriptionTextViewController.text else {
            return
        }
        let ingredients = ingredientInputViewControllers.map({ $0.textViewController?.text }).compactMap({ $0 })
        guard let info = infoTextViewController.text else {
            return
        }
        let id = recipe.id
        let updatingRecipe = UpdatingRecipeStructure(id: id, name: name, duration: 100, description: description, info: info, ingredients: ingredients)
        delegate?.updateRecipeScreenUpdateRecipe(updatingRecipe)
    }

    @objc private func addIngredient() {
        let ingredientInputView = addRecipeScreenView.addIngredientInputView()
        ingredientInputView.placeholderLabel.text = "sdfdsfsdf"
        let textViewController = AUIEmptyTextViewController()
        textViewController.addDidChangeTextObserver(self)
        let textViewTextInputController = AUIResponsiveTextViewTextInputViewController()
        textViewTextInputController.textViewController = textViewController
        textViewTextInputController.responsiveTextInputView = ingredientInputView
        ingredientInputViewControllers.append(textViewTextInputController)
    }
    
    private func pickDuration() {
        let durationInSeconds = durationDatePickerControler.countDownDuration
        let durationInMinutes = Int(durationInSeconds / 60)
        addRecipeScreenView.durationInputView.textField.text = localizer.localizeText("durationInMinutes", "\(durationInMinutes)")
    }

    // MARK: Content

    private func setContent() {
        addRecipeScreenView.backButton.setTitle(localizer.localizeText("back"), for: .normal)
        addRecipeScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addRecipeScreenView.titleLabel.text = localizer.localizeText("title")
        addRecipeScreenView.nameTextInputView.titleLabel.text = localizer.localizeText("recipeName")?.uppercased()
        addRecipeScreenView.infoTextInputView.titleLabel.text = localizer.localizeText("recipeInfo")?.uppercased()
        addRecipeScreenView.ingredientsLabel.text = localizer.localizeText("recipeIngredients")?.uppercased()
        addRecipeScreenView.addIngredientButton.setTitle(localizer.localizeText("recideAddIngredient")?.uppercased(), for: .normal)
        addRecipeScreenView.descriptionInputView.titleLabel.text = localizer.localizeText("recideDescription")?.uppercased()
        addRecipeScreenView.durationInputView.titleLabel.text = localizer.localizeText("recideDuration")
        setRecipeContent()
    }
    
    private func setRecipeContent() {
        nameTextViewController.text = recipe.name
        descriptionTextViewController.text = recipe.description
        infoTextViewController.text = recipe.info
        durationDatePickerControler.countDownDuration = TimeInterval(recipe.duration)
    }

}

