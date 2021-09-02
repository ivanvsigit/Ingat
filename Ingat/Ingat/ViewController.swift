//
//  ViewController.swift
//  Ingat
//
//  Created by Ivan Valentino Sigit on 05/05/21.
//

import UIKit

class ViewController: UIViewController{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [TaskItem]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnView: UIView!
    @IBOutlet var segment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        
        btnView.layer.cornerRadius = 30
        segment.overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func didTapAdd(){
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success{
                
            } else if error != nil{
                print("error occured")
            }
        })
        
        vc.title = "New Task"
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
//                self.navigationController?.popToRootViewController(animated: true)
                
                self.createItem(title: title, desc: body, due: date)
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)

                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil{
                        print("something went wrong")
                    }
                })
                
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return models.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = models[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = model.title
//        return cell
//    }
    
    //Checkmark item
    @IBAction func didTapCheck(){
        
    }
    
    // Core Data
    func getAllItems(){
        do{
            models = try context.fetch(TaskItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("ambil data")
            }
        } catch {
            
        }
    }
    
    func createItem(title: String, desc: String, due: Date){
        let newItem = TaskItem(context: context)
        newItem.title = title
        newItem.desc = desc
        newItem.due = due
        
        do{
            try context.save()
            getAllItems()
            print("berhasil")
        } catch{
            
        }
    }
    
    func deleteItem(item: TaskItem){
        context.delete(item)
        
        do{
            try context.save()
            getAllItems()
        } catch{
            
        }
    }
    
    func updateItem(item: TaskItem, newTitle: String, newDesc: String, newDue: Date){
        item.title = newTitle
        item.desc = newDesc
        item.due = newDue
        
        do{
            try context.save()
            getAllItems()
        } catch{
            
        }
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "add") as? AddViewController else{
                return
            }
            
            vc.title = item.title
            vc.titleF?.placeholder = item.title
            vc.bodyF?.placeholder = item.desc
            vc.datePick?.date = item.due!
        
            vc.completion = { title, body, date in
                DispatchQueue.main.async {
    //                self.navigationController?.popToRootViewController(animated: true)
                    
                    self.updateItem(item: item, newTitle: title, newDesc: body, newDue: date)
                    
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.sound = .default
                    content.body = body

                    let targetDate = date
                    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)

                    let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                        if error != nil{
                            print("something went wrong")
                        }
                    })
                    
                    
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        
        let date = models[indexPath.row].due
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date!)
        
//        if models.contains(indexPath.row) {
//                cell?.accessoryType = .checkmark
//            } else {
//                cell?.accessoryType = .none
//            }
        
        return cell
    }
    
}

