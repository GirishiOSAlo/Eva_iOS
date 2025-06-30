//
//  CalenderVC.swift
//  EvaConnect
//
//  Created by Metis on 29/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import Alamofire
import FSCalendar

class CalendarVC: BaseVC {
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    //MARK: OUTLETS
    @IBOutlet weak var dayTxt: UITextField!
    @IBOutlet weak var monthTxt: UITextField!
    @IBOutlet weak var yearTxt: UITextField!
    @IBOutlet weak var pickerStatus: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteDesPlaceHolder: UILabel!
    @IBOutlet weak var noteDescritionTxt: UITextView!
    @IBOutlet weak var calendarVIew: UIView!
    @IBOutlet weak var newEventBtn:UIButton!
//    @IBOutlet weak var jobCircle: UIView!
//    @IBOutlet weak var notesCircle: UIView!
//    @IBOutlet weak var eventCircle: UIView!
//    @IBOutlet weak var meetingCircle: UIView!
    @IBOutlet weak var showNoEvent: UIView!
    @IBOutlet weak var showingEvent: UIView!
    @IBOutlet weak var calendarEventTableView: UITableView!
//    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var noEventsLabel: UILabel!
    
    //MARK: VARIABLES
    fileprivate weak var calendarNew: FSCalendar!
    private var contentPicker: BottomContentPicker!
    var getDate: Date?
    var calendarListingDay: Date? = nil
    var yearArray: [String] = []
    var monthArray: [String] = []
    var eventDateArray: [Date] = []
    var jobDateArray: [Date] = []
    var notesDateArray: [Date] = []
    var meetingDateArray: [Date] = []
    var eventWithMultipleDates: [(date: String, type: CalendarObjectType)] = []
    var selectedCategoryColor: UIColor = Constants.AppColorLiteral.signUpNew
    let years = (2020...2100).map { String($0) }
//    var calendarEvents: [CalendarModelList] = []
    var calendarEvents: [CalenderEventsdata] = []
    var calendarListArrayByMonth: [CalendarModelByMonth] = []
    var selectedDate = ""
    
    lazy var dateFormatterCicle: DateFormatter = {
        let formatter = DateFormatter();
        formatter.dateFormat = "dd-MM-yyyy";
        return formatter;
    }()
    
    fileprivate lazy var dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    lazy var datePick1: UIPickerView = {
        let picker = UIPickerView()
        getMonth()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    lazy var datePick2: UIPickerView = {
        let picker = UIPickerView()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date())
        getYear()
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.selectRow(0, inComponent: 0, animated: true)
        picker.dataSource = self
        return picker
    }()
    
    var calenderAdded = false
    var btnChange = 0
    
    //MARK: VIEW LIFECYLCE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // addObservers()
        setContentPickerView()
        createButton.layer.cornerRadius = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        let date = Date()
        let currentDate = self.dateFormat.string(from: date)
        FetchCalenderEventList(date: currentDate)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(callUpdateAPI), name: NSNotification.Name(rawValue: "callUpdateApi"), object: nil)
    }
    
    @objc func callUpdateAPI(){
        setLayOut()
        calenderInitLoad()
//        getAllCalenderListByMonth(getDate: getDate ?? Date())
//        getAllCalenderListByDate(getDate: calendarListingDay ?? Date())
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLayOut()
        calenderInitLoad()
//        getAllCalenderListByMonth(getDate: getDate ?? Date())
//        getAllCalenderListByDate(getDate: calendarListingDay ?? Date())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        blurView.isHidden = true
    }
    
    @IBAction func backForwardBtnTapped(_ sender: UIButton) {
        let isBack = sender.tag == 0
        calendarNew.setCurrentPage(isBack ? calendarNew.currentPage.previousMonth : calendarNew.currentPage.nextMonth, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MeetingEventDialogVC, let calendarObj = sender as? CalendarModelList {
            self.definesPresentationContext = true
            destination.modalPresentationStyle = .overCurrentContext
            destination.calendarObject = calendarObj
            destination.delegate = self
        }
    }
    
    @IBAction func createEventBtnTapped(_ sender: Any) { contentPicker.presentView() }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
//        if touch?.view == blurView {
//            newEventBtn.setBackgroundImage(#imageLiteral(resourceName: "addNew"), for: .normal)
//            blurView.isHidden = true
//        }
        self.pickerStatus.isHidden = true
    }
}

//MARK: IBOutlet Action
extension CalendarVC {
    
    @IBAction func addNotes(_ sender: Any) {
    }
    
    //Opening Calendar Menu
    @IBAction func openCalenderMenu(_ sender: UIButton) {
        if btnChange == 0 {
            newEventBtn.setBackgroundImage(#imageLiteral(resourceName: "CloseNewPost"), for: .normal)
//            blurView.isHidden = false
            btnChange = 1
        }
        else {
            newEventBtn.setBackgroundImage(#imageLiteral(resourceName: "addNew"), for: .normal)
//            blurView.isHidden = true
            btnChange = 0
        }
    }
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
}

//MARK: Calendar Delegate
extension CalendarVC: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            self.dayTxt.text = formatDateForDayDisplay(date: date)
            calendar.setCurrentPage(Date(), animated: true)
        }
//        getAllCalenderListByDate(getDate:date)
        calendar.setCurrentPage(date, animated: true)
        print("did select date \(self.dateFormat.string(from: date))")
        self.selectedDate = self.dateFormat.string(from: date)
        FetchCalenderEventList(date: selectedDate)
        self.monthTxt.text = formatDateForMonthDisplay(date: date)
        self.dayTxt.text = formatDateForDayDisplay(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = self.dateFormatterCicle.string(from: date)
        if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .event }) &&
           eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .meeting }) &&
           eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .note }) {
            return 3
        } else if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .event }) &&
                  eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .meeting }) {
            return 2
        } else if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .event }) &&
                  eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .note }) {
            return 2
        } else if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .meeting }) &&
                  eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .note }) {
            return 2
        } else {
            if  self.eventDateArray.contains(self.dateFormatterCicle.date(from: self.dateFormatterCicle.string(from: date))!) {
                calendar.appearance.eventDefaultColor = AppColors.appRed
                return 1
            }
            if self.meetingDateArray.contains(self.dateFormatterCicle.date(from: self.dateFormatterCicle.string(from: date))!) {
                calendar.appearance.eventDefaultColor = AppColors.appGreen
                return 1
            }
            if self.notesDateArray.contains(self.dateFormatterCicle.date(from: self.dateFormatterCicle.string(from: date))!) {
                calendar.appearance.eventDefaultColor = AppColors.appBlue
                return 1
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatterCicle.string(from: date)
        if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .event }) &&
           eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .meeting }) &&
           eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .note }) {
            return [AppColors.appRed, AppColors.appGreen, AppColors.appBlue]
        } else if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .event }) &&
                  eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .meeting }) {
            return [AppColors.appRed, AppColors.appGreen]
        } else if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .event }) &&
                  eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .note }) {
            return [AppColors.appRed, AppColors.appBlue]
        } else if eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .meeting }) &&
                  eventWithMultipleDates.contains(where: { $0.date == key && $0.type == .note }){
            return [AppColors.appGreen, AppColors.appBlue]
        } else {
            if self.meetingDateArray.contains(self.dateFormatterCicle.date(from: key)!) { return [AppColors.appGreen] }
            if self.eventDateArray.contains(self.dateFormatterCicle.date(from: key)!) { return [AppColors.appRed] }
            if self.notesDateArray.contains(self.dateFormatterCicle.date(from: key)!) { return [AppColors.appBlue] }
        }
        
        return nil
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        getAllCalenderListByMonth(getDate: calendar.currentPage)
    }
    
    //change big circle color when tap on it
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return Constants.AppColorLiteral.nextButtonColor
        
    }
    //big circle Backgroundcolor
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.white
    }
    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        print("did select date \(self.formatter.string(from: date))")
//        self.configureVisibleCells()
//    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.dateFormat.string(from: date))")
    }
}
//MARK:-TextField & TextView Delegate's
extension CalendarVC: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tf = textField
        
        switch tf {
            
        case monthTxt:
            
            if monthTxt.text?.count != 0 || !monthTxt.text!.isEmpty{
                
                monthTxt.inputView = datePick1
                datePick1.tag = 0
                
            }
            else if monthTxt.text!.isEmpty{
                //self.pickerStatus.isHidden = true
                monthTxt.inputView = datePick1
                datePick1.tag = 0
            }
            monthTxt.tintColor = UIColor.clear
            
        case yearTxt:
            
            if yearTxt.text?.count != 0 || !yearTxt.text!.isEmpty{
                
                yearTxt.inputView = datePick2
                datePick2.tag = 1
                
            }
            else if yearTxt.text!.isEmpty{
                
                yearTxt.inputView = datePick2
                datePick2.tag = 1
                
            }
            yearTxt.tintColor = UIColor.clear
            
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if noteDescritionTxt.text.count > 0  && noteDescritionTxt.text.count != 0 && !noteDescritionTxt.text.isEmpty{
            noteDesPlaceHolder.isHidden = true
        }
        else {
            noteDesPlaceHolder.isHidden = false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        noteDesPlaceHolder.isHidden = true
        return true
    }
}

//MARK: UI Update
extension CalendarVC {
    
    func setLayOut() {
        
        createButton.isHidden = false
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 20
        datePicker.minimumDate = Date()
        monthTxt.delegate = self
        yearTxt.delegate = self
        noteDescritionTxt.delegate = self
        calendarEventTableView.dataSource = self
        calendarEventTableView.delegate = self
//        calendarEventTableView.estimatedRowHeight = 100
        self.showingEvent.isHidden = false
        //self.showNoEvent.isHidden = true
        self.calendarEventTableView.isHidden = false
        self.calendarEventTableView.reloadData()
//        jobCircle.layer.cornerRadius = jobCircle.frame.height / 2
//        notesCircle.layer.cornerRadius = notesCircle.frame.height / 2
//        eventCircle.layer.cornerRadius = eventCircle.frame.height / 2
//        meetingCircle.layer.cornerRadius = meetingCircle.frame.height / 2
        //monthTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //yearTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        newEventBtn.setBackgroundImage(#imageLiteral(resourceName: "addNew"), for: .normal)
        //setButton(view: newEventBtn,ConnerByHeight: true)
        self.dayTxt.text = formatDateForDayDisplay(date: Date())
        self.monthTxt.text = formatDateForMonthDisplay(date: Date())
        self.yearTxt.text = formatDateForYearDisplay(date: Date())
        
        calendarEventTableView.registerCell(withType: EventCell.self)
        calendarEventTableView.registerCell(withType: MeetingCell.self)
        calendarEventTableView.registerCell(withType: JobCell.self)
        
    }
    
    private func setContentPickerView() {
        var contents: [(title: String, type: BottomContentPicker.BottomContentType)] = [  (title: "Create a meeting", type: .meeting),
                                                                                          (title: "Create a note", type: .note) ]
//        if LoggedUserDetails.shared.user?.type == userType.user.rawValue { contents.remove(at: 0) }
        contentPicker = BottomContentPicker(contents: contents)
        contentPicker.delegate = self
        contentPicker.addConstraint(UIApplication.shared.keyWindow ?? view)
    }
    
    func calenderInitLoad() {
        if calenderAdded {
            return
        }
        
        calenderAdded = true
        let dd : Int = Date().yearMonthDayInt()!
        print(dd)
        let calendar = FSCalendar.init(frame: CGRect(x:0, y: 0, width: calendarVIew.frame.size.width, height: calendarVIew.frame.size.height));
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .white
        calendar.appearance.eventSelectionColor = .clear
        calendar.appearance.todayColor = Constants.AppColorLiteral.nextButtonColor
        calendar.appearance.selectionColor = Constants.AppColorLiteral.nextButtonColor
        calendar.scrollEnabled = false
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        //        calendar.appearance.titleDefaultColor = .green
        calendar.appearance.titlePlaceholderColor = .clear
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.caseOptions = .headerUsesUpperCase
        calendar.select(Date())
        calendar.appearance.eventDefaultColor = .black
        calendarVIew.addSubview(calendar)
        calendarNew = calendar
        calendar.appearance.weekdayTextColor = UIColor(hex: "BEBEBE")
        calendar.appearance.weekdayFont = UIFont(defaultFontStyle: .regular, textStyle: .body, size: 13)
        calendar.appearance.headerTitleFont = UIFont(defaultFontStyle: .bold, textStyle: .body, size: 18)
        calendar.appearance.headerTitleColor = UIColor(hex: "1D2634")
        calendar.scrollDirection = .horizontal
        calendar.scrollEnabled = true
        calendar.firstWeekday = 2
        let previousBtn = UIButton(type: .custom)
        previousBtn.frame = CGRect(x: 0, y: 0 + 5, width:95, height: 34)
        previousBtn.backgroundColor = .white
        previousBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        previousBtn.setImage(UIImage (named: "c_left-arrow"), for: .normal)
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [weak self] in
            self?.calendarVIew.alpha = 1
            self?.forwardBtn.alpha = 1
            self?.backBtn.alpha = 1
            self?.view.backgroundColor = UIColor(named: "Background")!
        }.startAnimation()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: CUSTOM FUNCTION
extension CalendarVC {
    
    // Getting Month & Year
    func getYear() {
        let d2d = DateFormatter()
        d2d.dateFormat = "yyyy"
        let i2 = Int(d2d.string(from: Date())) ?? 0
        
        for i in 1990...i2+20{
            yearArray.append("\(i)")
        }
    }
    
    func fillMultipleEvents() {
        eventWithMultipleDates.removeAll()
        eventWithMultipleDates.append(contentsOf: eventDateArray.map({ (date: dateFormatterCicle.string(from: $0), type: .event) }))
        eventWithMultipleDates.append(contentsOf: meetingDateArray.map({ (date: dateFormatterCicle.string(from: $0), type: .meeting) }))
        eventWithMultipleDates.append(contentsOf: notesDateArray.map({ (date: dateFormatterCicle.string(from: $0), type: .note) }))
        print("eventWithMultipleDates", eventWithMultipleDates)
    }
    
    func getMonth(){
        
        let dateFormatter77 = DateFormatter()
        let today = Date()
        let currentCalendar = Calendar.current
        let yearComponents = currentCalendar.component(.year, from: today)
        let currentYear = yearComponents
        for months in 0..<12 {
            print(String(format: "%@ %i", dateFormatter77.monthSymbols[months], currentYear))
            monthArray.append(dateFormatter77.monthSymbols[months])
        }
        
    }
    func formatDateForMonthDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    func formatDateForYearDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: date)
    }
    func formatDateForDayDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}

//MARK: PICKER DELEGATES
extension CalendarVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return monthArray.count
        } else  {
            return yearArray.count
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return monthArray[row]
            
        } else  {
            let d2d = DateFormatter()
            d2d.dateFormat = "yyyy"
            return d2d.string(from:d2d.date(from: yearArray[row]) ?? Date())
            
        }
        
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        if pickerView.tag == 0 {
//            monthTxt.text = monthArray[row]
//            let d2d = DateFormatter()
//            let d3d = DateFormatter()
//            d2d.dateFormat = "mmmm"
//            d3d.dateFormat = "yyyy-MM-dd"
//            let makeDate = "\(yearTxt.text!) \(monthTxt.text!) \(dayTxt.text!)"
//            getAllCalenderListByMonth(getDate:d3d.date(from: makeDate) ?? Date())
//            getAllCalenderListByDate(getDate: d3d.date(from: makeDate) ?? Date())
//            calendarNew.setCurrentPage(d3d.date(from:makeDate) ?? Date(), animated: true)
//        } else if pickerView.tag == 1 {
//
//            let d2d = DateFormatter()
//            d2d.dateFormat = "yyyy"
//            let d3d = DateFormatter()
//            d3d.dateFormat = "yyyy-MM-dd"
//            yearTxt.text = d2d.string(from:d2d.date(from: yearArray[row]) ?? Date())
//            let makeDate = "\(yearTxt.text!) \(monthTxt.text!) \(dayTxt.text!)"
//            getAllCalenderListByMonth(getDate:d3d.date(from:makeDate)!)
//            getAllCalenderListByDate(getDate: d3d.date(from:makeDate) ?? Date())
//            calendarNew.setCurrentPage(d2d.date(from:yearArray[row]) ?? Date(), animated: true)
//
//        }
//    }
}

//MARK: NETWORK CALL
extension CalendarVC {
    
//    func getAllCalenderListByDate(getDate: Date) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let myCurrentDate = formatter.string(from: getDate)
//        let param:Parameters = [
//            "user_id" :  LoggedUserDetails.shared.user?.id ?? 0,
//            "date":myCurrentDate
//        ]
//        //showActivity()
//        NetworkManagerr.request(EndPoints.getCalendarByDate, method: .post, parameters: param) { (response) in
//            //self.hideActivity()
//            if response.result.isSuccess {
//                let jsonDecoder = JSONDecoder()
//                let resposeData = try! jsonDecoder.decode(AllCalendarModelList.self, from:response.data!)
//                if resposeData.error == false {
//                    self.calendarEvents.removeAll()
//                    for i in resposeData.data! {
//                        self.calendarEvents.append(i)
//                    }
//                    self.calendarEvents = Array(Set(self.calendarEvents))
//                    if self.calendarEvents.count != 0 {
//                        self.showingEvent.isHidden = false
//                        self.calendarEventTableView.isHidden = false
//                        self.calendarEventTableView.reloadData()
//                    }
//                    else {
//                        self.showingEvent.isHidden = true
////                        self.calendarEventTableView.isHidden = true
//                    }
//                    self.calendarEventTableView.reloadData()
//                    self.calendarNew.reloadData()
//                }
//                else {
//                    self.presentAlert("Error", nil, response.result.error)
//                }
//            }
//            else {
//                self.presentAlert("Error", nil, response.result.error)
//            }
//        }
//
//        calendarListingDay = getDate
//    }
    
//    func getAllCalenderListByMonth(getDate: Date) {
//
//        let getMonth = DateFormatter()
//        getMonth.dateFormat = "MM"
//        let getYear = DateFormatter()
//        getYear.dateFormat = "yyyy"
//
//        let gettingMonth = getMonth.string(from: getDate)
//        let gettingYear = getYear.string(from: getDate)
//
//        let param: AFParameters = [
//            "user_id" :  LoggedUserDetails.shared.user?.id ?? 0,
//            "month": gettingMonth,
//            "year": gettingYear
//        ]
//        //showActivity()
//        NetworkManagerr.request(EndPoints.getCalendarByMonth, method: .post, parameters: param) { (response) in
//            //self.hideActivity()
//            if response.result.isSuccess {
//                let jsonDecoder = JSONDecoder()
//                let resposeData = try! jsonDecoder.decode(AllCalendarModelByMonth.self, from:response.data!)
//                if resposeData.error == false {
//                    self.calendarEvents.removeAll()
//                    self.calendarListArrayByMonth.removeAll()
//                    for i in resposeData.data! {
//                        self.calendarListArrayByMonth.append(i)
//                    }
//                    if self.calendarListArrayByMonth.count != 0 {
//                        let dateFormatter4 = DateFormatter()
//                        dateFormatter4.dateFormat = "yyyy-MM-dd"
//
//                        self.eventDateArray.removeAll()
//                        self.jobDateArray.removeAll()
//                        self.notesDateArray.removeAll()
//                        self.meetingDateArray.removeAll()
//
//                        let event = self.calendarListArrayByMonth.filter{$0.objectType! == .event}
//                        let job = self.calendarListArrayByMonth.filter{$0.objectType! == .job}
//                        let notes = self.calendarListArrayByMonth.filter{$0.objectType! == .note}
//                        let meeting = self.calendarListArrayByMonth.filter{$0.objectType! == .meeting}
//                        for i in event {
//                            self.eventDateArray.append(dateFormatter4.date(from: i.occurrenceDate!)!)
//                        }
//                        for i in job {
//                            self.jobDateArray.append(dateFormatter4.date(from: i.occurrenceDate!)!)
//                        }
//                        for i in notes {
//                            self.notesDateArray.append(dateFormatter4.date(from: i.occurrenceDate!)!)
//                        }
//                        for i in meeting {
//                            self.meetingDateArray.append(dateFormatter4.date(from: i.occurrenceDate!)!)
//                        }
//                        self.getAllCalenderListByDate(getDate: getDate)
//                        self.fillMultipleEvents()
//                        self.calendarNew.reloadData()
//                    }
//                }
//
//            }
//            else {
//                self.presentAlert("Error", nil, response.result.error)
//            }
//        }
//
//        self.getDate = getDate
//    }
    
    func FetchCalenderEventList(date: String){
        let parameters = ["selected_date": date] as [String : Any]
        self.showActivity()
        NetworkManagerr.request(EndPoints.calenderEventList, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                self.hideActivity()
                do {
                    let jsonDecoder = JSONDecoder()
                    let eventDataRoot = try jsonDecoder.decode(CalenderEventListDataModel.self, from: response.data!)
                    
                    if !(eventDataRoot.error!), ((eventDataRoot.data?.count ?? 0) > 0) {
                        self.calendarEvents = []
                        self.calendarEvents = eventDataRoot.data ?? []
                        self.calendarEventTableView.reloadData()
                        self.noEventsLabel.isHidden = true
                    } else {
                        self.calendarEvents = []
                        self.calendarEventTableView.reloadData()
                        self.noEventsLabel.isHidden = false
                    }
                } catch {
                    print("\(String(describing: response.result.error?.localizedDescription))")
                }
            }
            else {
                self.hideActivity()
                self.presentAlert("Error", nil, response.result.error)
            }
        }
        
    }
}

//MARK: TABLEVIEW DELEGATES
extension CalendarVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataArray = calendarEvents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.id(), for: indexPath) as! EventCell
//        cell.updateUI(data: dataArray, type: dataArray.objectType!)
        cell.updateUI(data: dataArray)
        cell.openCell.tag = indexPath.row
        cell.openCell.addTarget(self, action:#selector(openCalenderType(sender:)), for: .touchUpInside)
        return cell
        //
        //            if dataArray.objectType! == .event {
        //
        //            }
        //            else if dataArray.objectType! == .meeting {
        //                let cell = tableView.dequeueReusableCell(withIdentifier: MeetingCell.id(), for: indexPath) as! MeetingCell
        //                cell.updateUI(data: dataArray)
        //                cell.openCell.tag = indexPath.row
        //                cell.openCell.addTarget(self, action:#selector(openCalenderType(sender:)), for: .touchUpInside)
        //                return cell
        //            }
        // return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = calendarEvents[indexPath.row]
        if obj.type == "Notes" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
            vc.noteID = calendarEvents[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MeetingDetailVC") as! MeetingDetailVC
            vc.meetingId = calendarEvents[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 98
    }//UITableView.automaticDimension }
    
}

//MARK: Custom Redirection Function
extension CalendarVC {
    
    @objc func openCalenderType(sender: UIButton) {
        print("tag", sender.tag)
        calenderType(at: sender.tag)
    }
    
    private func calenderType(at index: Int) {
        print("hello i am called")
        if calendarEvents.count != 0 && !calendarEvents.isEmpty {
            let bindData = calendarEvents[index]
//            switch bindData.objectType {
//            case .job:
//                makeAlert(titleMsg: "Job Title", messageData: bindData.objectDetails?.name ?? "No Job Title")
//            default:
//                performSegue(withIdentifier: Constants.Segues.meetingDialog, sender: bindData)
//            }
        }
    }
}


extension CalendarVC: BottomContentPickerDelegate {
    
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        switch content {
        case .event:
//            let vc = StoryboardRouter.createEvent()
//            navigationController?.pushViewController(vc, animated: true)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NoteDetailVC") as! NoteDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
        case .meeting:
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "MeetingDetailVC") as! MeetingDetailVC
//            self.navigationController?.pushViewController(vc, animated: true)
////            let vc = StoryboardRouter.createMeeting()
////            navigationController?.pushViewController(vc, animated: true)
            let vc = StoryboardRouter.createMeeting()
            navigationController?.pushViewController(vc, animated: true)
        case .note:
            let vc = StoryboardRouter.createNote()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("none")
        }
    }
    
}

extension CalendarVC: MeetingEventDialogDelegate {
    
    func eventDialogDismiss(calendar: CalendarModelList) {
        if calendar.objectType == .meeting {
            let vc = StoryboardRouter.meetingView()
            vc.navigationType = .dialog
            vc.meetingId = calendar.objectID
            navigationController?.pushViewController(vc, animated: true)
        } else if calendar.objectType == .note {
            let vc = StoryboardRouter.createNote()
            vc.note = calendar
            navigationController?.pushViewController(vc, animated: true)
        } else {
//            let vc = StoryboardRouter.eventCommentVC()
//            vc.eventId = calendar.objectID
//            vc.userId = calendar.userID
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
