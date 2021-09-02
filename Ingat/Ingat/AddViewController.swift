//
//  AddViewController.swift
//  Ingat
//
//  Created by Ivan Valentino Sigit on 05/05/21.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleF: UITextField!
    @IBOutlet var bodyF: UITextField!
    @IBOutlet var datePick: UIDatePicker!
    @IBOutlet var addButton: UIButton!
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePick.setValue(UIColor.white, forKeyPath: "textColor")
        datePick.tintColor = #colorLiteral(red: 0, green: 0.4773983955, blue: 0.7512665391, alpha: 1)
        titleF.delegate = self
        bodyF.delegate = self
        titleF.tintColor = .systemBlue
        bodyF.tintColor = .systemBlue
        addButton.layer.cornerRadius = 10
    }
    
    @IBAction func didTapAddButton(){
        
        if let titleText = titleF.text, !titleText.isEmpty, let bodyText = bodyF.text, !bodyText.isEmpty{
                let targetDate = datePick.date
//                let view: ViewController = ViewController()
//                view.createItem(title: titleText, desc: bodyText, due: targetDate)
                completion?(titleText, bodyText, targetDate)
        } else {
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
