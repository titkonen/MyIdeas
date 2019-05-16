import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
  
  // Properties
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  var itemID = -1
  
  // Override init
  override init() {
    super.init()
    itemID = DataModel.nextChecklistItemID()
  }
  
  // deinit
  deinit {
    removeNotification()
  }
  
  // Functions
  func toggleChecked() {
    checked = !checked
  }
  
      // Notifications schedule
  func scheduleNotification() {
    removeNotification()
    
    if shouldRemind && dueDate > Date() {
      // 1
      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = UNNotificationSound.default
      
      // 2
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
      let center = UNUserNotificationCenter.current()
      center.add(request)
      
      print("Scheduled: \(request) for itemID: \(itemID)")
    }
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }
  

  
  
} // End of class
