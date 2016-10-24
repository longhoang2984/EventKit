//
//  ViewController.swift
//  EventKit Demo
//
//  Created by Hoàng Cửu Long on 10/5/16.
//  Copyright © 2016 Hoàng Cửu Long. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    let eventStore = EKEventStore()
    
    var calendars: [EKCalendar] = [EKCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadCalendars() {
        self.calendars = eventStore.calendars(for: .event)
        print(calendars)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch (status) {
        case .notDetermined:
            // Lần đầu vào app
                requestAccessToCalendar()
        case .authorized:
            // User đã cho phép sử dụng
                loadCalendars()
            
        case .restricted, .denied:
            print("User Denied")
        
        }
    }
    
    func requestAccessToCalendar() {
        
        eventStore.requestAccess(to: .event) { (isAllowed, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if isAllowed {
                    print("User Allowed")
                    self.loadCalendars()
                } else {
                    print("User Denied")
                }
            }
        }
    }
    

}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let event = calendars[indexPath.row]
        cell.textLabel?.text = event.title
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventVC") as? EventViewController else {return}
        vc.calendar = calendars[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

