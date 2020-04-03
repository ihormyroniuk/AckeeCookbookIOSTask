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

class AddRecipeScreenController: AUIDefaultScreenController, AddRecipeScreen, AUITextViewControllerDidChangeTextObserver {

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

    // MARK: Setup

    override func setup() {
        super.setup()
        addRecipeScreenView.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        addRecipeScreenView.addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        nameTextViewController.textView = addRecipeScreenView.nameTextInputView.textView
        nameTextViewController.addDidChangeTextObserver(self)
        infoTextViewController.textView = addRecipeScreenView.infoTextInputView.textView
        infoTextViewController.addDidChangeTextObserver(self)
        setContent()
    }

    // MARK: Events

    func textViewControllerDidChangeText(_ textViewController: AUITextViewController) {
        addRecipeScreenView.setNeedsLayout()
        addRecipeScreenView.layoutIfNeeded()
    }

    // MARK: Actions

    @objc private func back() {
        delegate?.addRecipeScreenBack(self)
    }

    @objc private func add() {
        let recipe = StructureCreatingRecipe(name: "Ackee name \(UUID().uuidString)", description: "description", ingredients: ["ingredient1", "ingredient2"], duration: 10, info: "info")
        delegate?.addRecipeScreenAddRecipe(recipe)
    }

    // MARK: Content

    private func setContent() {
        addRecipeScreenView.backButton.setTitle(localizer.localizeText("back"), for: .normal)
        addRecipeScreenView.addButton.setTitle(localizer.localizeText("add"), for: .normal)
        addRecipeScreenView.titleLabel.text = localizer.localizeText("title")
        addRecipeScreenView.nameTextInputView.titleLabel.text = localizer.localizeText("recipeName")?.uppercased()
        addRecipeScreenView.infoTextInputView.titleLabel.text = localizer.localizeText("recipeInfo")?.uppercased()
    }

}
