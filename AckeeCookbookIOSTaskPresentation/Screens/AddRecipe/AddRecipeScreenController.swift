//
//  AddRecipeScreenController.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AFoundation
import AckeeCookbookIOSTaskBusiness

class AddRecipeScreenController: AUIDefaultScreenController, AddRecipeScreen, AUITextViewControllerDidChangeTextObserver, AUIControlControllerDidValueChangedObserver {

    // MARK: AddRecipeScreen

    weak var delegate: AddRecipeScreenDelegate?

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
    private let durationTextViewController = AUIEmptyTextViewController()
    private let durationDatePickerControler = AUIDefaultDatePickerController()
    private let tapGestureRecognizer = UITapGestureRecognizer()

    // MARK: Setup

    override func setup() {
        super.setup()
        addRecipeScreenView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(sf))
        addRecipeScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        addRecipeScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        nameTextViewController.textView = addRecipeScreenView.nameTextInputView.textView
        nameTextViewController.addDidChangeTextObserver(self)
        infoTextViewController.textView = addRecipeScreenView.infoTextInputView.textView
        infoTextViewController.addDidChangeTextObserver(self)
        descriptionTextViewController.textView = addRecipeScreenView.descriptionInputView.textView
        descriptionTextViewController.addDidChangeTextObserver(self)
        addRecipeScreenView.addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
        durationTextViewController.textView = addRecipeScreenView.durationInputView.textField
        durationTextViewController.inputViewController = durationDatePickerControler
        durationTextViewController.addDidChangeTextObserver(self)
        durationDatePickerControler.countDownDuration = 50
        durationDatePickerControler.minuteInterval = 10
        durationDatePickerControler.mode = .countDownTimer
        durationDatePickerControler.addDidValueChangedObserver(self)
        setContent()
    }
    
    @objc func sf() {
        view.endEditing(true)
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
        delegate?.addRecipeScreenBack(self)
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
        let recipe = CreatingRecipeStructure(name: name, description: description, ingredients: ingredients, duration: 100, info: info)
        delegate?.addRecipeScreenAddRecipe(recipe)
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
    }

}
