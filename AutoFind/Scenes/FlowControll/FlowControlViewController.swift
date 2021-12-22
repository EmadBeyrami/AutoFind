//
//  FlowControlViewController.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import UIKit

class FlowControlViewController: UIViewController, Storyboarded {
    
    // Not using weak IBOultet because: https://stackoverflow.com/a/31395938
    @IBOutlet var toAppBtn: UIButton!
    @IBOutlet var changeLanguageButton: UIButton!
    @IBOutlet var noteLabel: UILabel!
    
    weak var coordinator: AppCoordinator?
    
    lazy var changeLanguageAlertController: UIAlertController = {
        
        let alert = UIAlertController(title: LocalizedStrings.changeLanguage.value, message: nil, preferredStyle: .actionSheet)
        
        let englishLangAlert = UIAlertAction(title: SupportedLanguages.english.text, style: .default) { [weak self] _ in
            guard let self = self else { return }
            LanguageManager.shared.currentLanguage = .english
            self.coordinator?.userChangedLanguage()
        }
        
        let finnishLangAlert = UIAlertAction(title: SupportedLanguages.finnish.text, style: .default) { [weak self] _ in
            guard let self = self else { return }
            LanguageManager.shared.currentLanguage = .finnish
            self.coordinator?.userChangedLanguage()
        }
        
        let germanLangAlert = UIAlertAction(title: SupportedLanguages.german.text, style: .default) { [weak self] _ in
            guard let self = self else { return }
            LanguageManager.shared.currentLanguage = .german
            self.coordinator?.userChangedLanguage()
        }
        
        let swedishLangAlert = UIAlertAction(title: SupportedLanguages.swedish.text, style: .default) { [weak self] _ in
            guard let self = self else { return }
            LanguageManager.shared.currentLanguage = .swedish
            self.coordinator?.userChangedLanguage()
        }
        
        let cancelAction = UIAlertAction(title: LocalizedStrings.cancel.value, style: .cancel)
        
        alert.addAction(englishLangAlert)
        alert.addAction(finnishLangAlert)
        alert.addAction(germanLangAlert)
        alert.addAction(swedishLangAlert)
        alert.addAction(cancelAction)
        return alert
    }()
    
    override func viewDidLoad() {
        setupView()
    }
    
    func setupView() {
        
        self.view.backgroundColor = UIColor.BackGround.lightGreenGreen
        // toApp Button
        toAppBtn.setTitle(LocalizedStrings.toCars.value, for: .normal)
        toAppBtn.setTitleColor(.Text.grayWhite, for: .normal)
        toAppBtn.addTarget(self, action: #selector(toCarSelection), for: .touchUpInside)
        
        // changeLanguageButton
        changeLanguageButton.backgroundColor = .BackGround.paleGrayBlack
        changeLanguageButton.setTitle(LocalizedStrings.changeLanguage.value, for: .normal)
        changeLanguageButton.setTitleColor(.Text.grayWhite, for: .normal)
        changeLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        
        // noteLabel
        noteLabel.textAlignment = .center
        noteLabel.font = UIFont.boldSystemFont(ofSize: 20)
        noteLabel.numberOfLines = 0
        noteLabel.text = LocalizedStrings.guideline.value + "\n Translation is copied from google translate :)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // UINavigationController
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Navigate to car selection scene
    @objc func toCarSelection() {
        coordinator?.toCarSelection()
    }
    
    // Present Change language AlertVC
    @objc func changeLanguage() {
        self.present(changeLanguageAlertController, animated: true, completion: nil)
    }
}
