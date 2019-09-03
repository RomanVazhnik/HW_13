//
//  Extension alert+ ViewController.swift
//  HW_13
//
//  Created by Роман Важник on 03/09/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit

extension ViewController {
    
    enum AlertType {
        case add
        case edit
    }
    
    func createAlertController(title: String,
                                       message: String,
                                       actionTitle: String,
                                       type: AlertType,
                                       index: Int = 0) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Добавляю текстовое поле
        alert.addTextField { (textField) in
            textField.placeholder = "Укажите название"
            if type == .edit {
                textField.text = self.tasks[index].name
            }
        }
        
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            if let taskNameTextField =  alert.textFields?.first?.text,
                !taskNameTextField.isEmpty {
                
                switch type {
                case .add:
                    self.saveContext(taskNameTextField)
                case .edit:
                    self.editData(index: index, newName: taskNameTextField)
                }
                
                self.tableView.reloadData()
            } else {
                self.defaultAlert(title: "Ошибка", message: "Введена пустая строка")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func secondAlert() {
        let alert = UIAlertController(title: "Введите название", message: "название: ", preferredStyle: .alert)
        alert.addTextField { (text) in
            text.placeholder = "Укажите название"
        }
        let action = UIAlertAction(title: "Посмотреть", style: .default) { (action) in
            self.findTasksAction(with: alert.textFields?.first?.text ?? "")
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func defaultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
