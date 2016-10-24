//
//  NewCalendarViewController.swift
//  EventKit Demo
//
//  Created by Hoàng Cửu Long on 10/5/16.
//  Copyright © 2016 Hoàng Cửu Long. All rights reserved.
//

import UIKit
import EventKit

class NewCalendarViewController: UIViewController {

    @IBOutlet weak var calendarTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewCalendarActionButton(_ sender: AnyObject) {
       
        guard let calendarTitle:String = calendarTitleTextField.text else {return}
        
        if calendarTitle == "" { return }
        
        // Create an Event Store instance
        let eventStore = EKEventStore()
        
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        newCalendar.title = calendarTitle
        
        // Lấy các source từ biến eventStore
        let sourcesInEventStore = eventStore.sources
        
        // Lọc ra những source có type là local, và chỉ lấy phần tử đầu tiên và add vào source của newCalendar
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        // Save Calendar vừa tạo
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            let _ = self.navigationController?.popViewController(animated: true)
        } catch {
            // Show bảng thông báo khi save calendar mới thất bại
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
