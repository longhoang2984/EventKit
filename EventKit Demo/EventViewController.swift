//
//  EventViewController.swift
//  EventKit Demo
//
//  Created by Hoàng Cửu Long on 10/5/16.
//  Copyright © 2016 Hoàng Cửu Long. All rights reserved.
//

import UIKit
import EventKit

class EventViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var calendar : EKCalendar?
    
    var events: [EKEvent] = [EKEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        let addEventButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEvent))
        self.navigationItem.rightBarButtonItem = addEventButton
    }
    
    func addNewEvent() {
        guard let newEventVC = self.storyboard?.instantiateViewController(withIdentifier: "newEventVC") as? NewEventViewController else {return}
        newEventVC.selectedCalendar = calendar
        self.navigationController?.pushViewController(newEventVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadEvents(calendar: calendar!)
    }
    
    func loadEvents(calendar: EKCalendar) {
        //  DateFormatter: dùng để chuyển kiểu String sang kiểu Date và ngược lại
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Chúng ta chỉ muốn lấy các event nằm trong khoảng thời gian nào đó, chúng không phải load lên hết
        let startDate = dateFormatter.date(from: "2016-01-01")
        let endDate = dateFormatter.date(from: "2016-12-31")
        
        if let startDate = startDate, let endDate = endDate {
            let eventStore = EKEventStore()
            
            // Dùng eventStore để tạo và thiết lập thuộc tính cho NSPredicate
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar])
            
            // Dùng NSPredicate vừa thiết lập để tìm ra những event phù hợp với điều kiện đưa ra
            self.events = eventStore.events(matching: eventsPredicate).sorted(){
                (e1: EKEvent, e2: EKEvent) -> Bool in
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
            tableView.reloadData()
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

extension EventViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let event = events[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = event.startDate.description
        return cell
    }
}
