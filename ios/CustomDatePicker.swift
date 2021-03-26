//
//  DatePicker.swift
//
//  Created by vibin joby on 2021-03-21.
//


import UIKit

class CustomDatePicker : UIPickerView{
  
  var restrictedDays  = [Int]()
  
  var dateCollection = [Date]()
  
  init() {
    super.init(frame: .zero);
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setRestrictedDays(_ val:[Int]) {
    restrictedDays = val
  }
  
  
  func selectedDate()->Int{
    dateCollection = buildDateCollection()
    var row = 0
    for index in dateCollection.indices{
      let today = Date()
      if Calendar.current.compare(today, to: dateCollection[index], toGranularity: .day) == .orderedSame{
        row = index
      }
    }
    return row
  }
  
  func buildDateCollection()-> [Date]{
    dateCollection.append(contentsOf: Date.nextYear(restrictedDays:restrictedDays))
    return dateCollection
  }
}

// MARK - Date extension
extension Date {
  static func nextYear(restrictedDays: [Int]) -> [Date]{
    return Date.next(restrictedDays : restrictedDays, numberOfDays: 30, from: Calendar.current.date(byAdding: .day, value: +1, to: Date())!)
  }
  
  static func next(restrictedDays : [Int] , numberOfDays: Int, from startDate: Date) -> [Date]{
    var dates = [Date]()
    for i in 0..<numberOfDays {
      if let date = Calendar.current.date(byAdding: .day, value: i, to: startDate) {
        let tempDate = Calendar.current.component(.weekday, from: date)
        if(!restrictedDays.contains(tempDate)) {
          dates.append(date)
        }
      }
    }
    return dates
  }
}

// MARK - UIPickerViewDelegate
extension CustomDatePicker : UIPickerViewDelegate{
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let date = formatDate(date: self.dateCollection[row])
    NotificationCenter.default.post(name: .dateChanged, object: nil, userInfo:["date":date])
    
  }
  func formatDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: date)
  }
}

// MARK - UIPickerViewDataSource
extension CustomDatePicker : UIPickerViewDataSource{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1;
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return dateCollection.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let label = formatDatePicker(date: dateCollection[row])
    return label
  }
  
  
  func formatDatePicker(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter.string(from: date)
  }
  
}

// MARK - Observer Notification Init
extension Notification.Name{
  static var dateChanged : Notification.Name{
    return .init("dateChanged")
  }
  
}
