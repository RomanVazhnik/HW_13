//
//  ViewController.swift
//  HW_13
//
//  Created by Роман Важник on 03/09/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let identifier = "cell"
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func setupNavigationController() {
        title = "Tasks"
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks,
                                                           target: self,
                                                           action: #selector(findTasts))
        
    }
    
    @objc private func findTasts() {
        secondAlert()
    }
    
    @objc private func addButtonPressed() {
        createAlertController(title: "Добавление задачи",
                              message: "Введите название",
                              actionTitle: "Добавить",
                              type: .add)
    }
    
    func saveContext(_ taskName: String) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else {
            return
        }
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext) as! Task
        
        task.name = taskName
        
        do {
            try managedContext.save()
            tasks.append(task)
            tableView.insertRows(at:
                [IndexPath(row: self.tasks.count-1, section: 0)],
                with: .right)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchData() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func editData(index: Int, newName: String) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let task = try managedContext.fetch(fetchRequest)[index]
            task.name = newName
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteData(at indexPath: IndexPath) {
        
        managedContext.delete(tasks[indexPath.row] as NSManagedObject)
        tasks.remove(at: indexPath.row)
        do {
            try managedContext.save()
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func findTasksAction(with name: String) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            fetchRequest.predicate = NSPredicate(format: "name == %@", NSString(string: name))
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 0 {
                defaultAlert(title: "Результат", message: "Задачи с именем \(name) не найдено")
            }
            var resultNames = ""
            for taskName in result {
                resultNames += (taskName.name ?? "") + " "
            }
            defaultAlert(title: "Результат", message: "Все задачи с заданным именем: \(resultNames)")
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editingAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    private func editingAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "editing") { (_, action, completion) in
            self.createAlertController(title: "Редактирование задачи",
                                  message: "Введите название",
                                  actionTitle: "Заменить",
                                  type: .edit,
                                  index: indexPath.row)
        }
        return action
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "delete") { (_, action, completion) in
            self.deleteData(at: indexPath)
        }
        return action
    }
}
