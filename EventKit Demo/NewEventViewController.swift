//
//  NewEventViewController.swift
//  EventKit Demo
//
//  Created by Hoàng Cửu Long on 10/24/16.
//  Copyright © 2016 Hoàng Cửu Long. All rights reserved.
//

import UIKit
import EventKit

class NewEventViewController: UIViewController {

    
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    // Lưu lại calendar User đã chọn
    var selectedCalendar: EKCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveEventActionButton(_ sender: AnyObject) {
        // Khởi tạo eventStore: 😂 cái này quá quen thuộc r nhĩ
        let eventStore = EKEventStore()
        
        // Tạo calendar của event theo calendar đã chọn trước đó
        if let calendarForEvent = eventStore.calendar(withIdentifier: self.selectedCalendar.calendarIdentifier)
        {
            let newEvent = EKEvent(eventStore: eventStore)
            
            newEvent.calendar = calendarForEvent
            
            // Nếu User không nhập tên event thì mặc định sẽ là New Event
            newEvent.title = (self.eventNameTextField.text != nil && !self.eventNameTextField.text!.isEmpty) ? self.eventNameTextField.text! : "New Event"
            newEvent.startDate = self.startDatePicker.date
            newEvent.endDate = self.endDatePicker.date
            
            // Lưu Event lại bằng cách sử dụng eventStore
            
            do {
                try eventStore.save(newEvent, span: .thisEvent, commit: true)
                
                let _ = self.navigationController?.popViewController(animated: true)
            } catch {
                let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
