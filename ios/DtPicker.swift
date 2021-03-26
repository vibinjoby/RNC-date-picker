//
//  RNCustomDatePicker.swift
//  TiffinFinds
//
//  Created by vibin joby on 2021-03-21.
//

import UIKit

class DtPicker:UITextField,UITextFieldDelegate {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setDefaultConfig()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  let datePicker = CustomDatePicker()
  var selectedDate = ""
  //"MM/dd/yyyy"
  var format = "MM/dd/yyyy"
  
  @objc var onDateChanged: RCTBubblingEventBlock?
  @objc var onDonePressed: RCTBubblingEventBlock?
  
  @objc var restrictedDays = [Int]() {
    didSet {
      setRestrictedDays()
    }
  }
  
  @objc var hint : String = "" {
    didSet {
      setHintConfig()
    }
  }
  
  @objc var dateFormat : String = "" {
    didSet {
      setDateFormat()
    }
  }
  
  func setRestrictedDays() {
    datePicker.setRestrictedDays(self.restrictedDays)
  }
  
  func setHintConfig() {
    self.placeholder = hint
  }
  
  func setDateFormat() {
    if(self.dateFormat != "") {
      self.format = self.dateFormat
    }
  }
  
  func setDefaultConfig() {
    self.delegate = self
    if #available(iOS 13.0, *) {
      self.tintColor = UIColor(cgColor: CGColor(red: 255, green: 255, blue: 255, alpha: 1))
    } else {
      // Fallback on earlier versions
    }
    self.borderStyle = .line
    datePicker.dataSource = datePicker
    datePicker.delegate = datePicker
    self.addTarget(self, action: #selector(showDatePicker), for: .touchDown)
  }
  
  @objc func showDatePicker() {
    self.tag = 1
    datePicker.selectRow(datePicker.selectedDate(), inComponent: 0, animated: true)
    self.inputView = datePicker
    let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
    
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
    
    toolBar.setItems([doneButton,space,cancelButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    toolBar.sizeToFit()
    
    self.inputAccessoryView = toolBar
    NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(notification:)), name:.dateChanged, object: nil)
  }
  
  @objc func cancelDatePicker(){
    self.endEditing(true)
  }
  
  @objc func doneDatePicker(){
    if self.selectedDate != ""{
      let dateFormatter = DateFormatter()
      dateFormatter.setLocalizedDateFormatFromTemplate(self.format)
      print(format)
      let date = dateFormatter.date(from: self.selectedDate)
      self.text = formatDate(date : date!)
      
      //Callback
      guard let onDonePressed = self.onDonePressed else { return }
      let params: [String : Any] = ["text": self.text!]
      onDonePressed(params)
    }
    self.endEditing(true)
    NotificationCenter.default.removeObserver(self, name: .dateChanged, object: nil)
  }
  
  func formatDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate(self.format)
    return dateFormatter.string(from: date)
  }
  
  @objc func dateChanged(notification:Notification){
    let userInfo = notification.userInfo
    if let date = userInfo?["date"] as? String{
      self.selectedDate = date
      guard let onDateChanged = self.onDateChanged else { return }
      let params: [String : Any] = ["text": self.selectedDate]
      onDateChanged(params)
    }
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return true
  }
}

@objc(DtPickerViewManager)
class DtPickerViewManager : RCTViewManager {
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  override func view() -> UIView! {
    return DtPicker()
  }
}
