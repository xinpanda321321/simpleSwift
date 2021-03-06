//
//  DetailsViewController.swift
//  JsonImportExport
//
//  Created by sinpanda on 5/7/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var date1TF: UITextField!
    @IBOutlet weak var time1TF: UITextField!
    @IBOutlet weak var time2TF: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var sc: UITextField!
    @IBOutlet weak var well: UITextField!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view6: UIView!
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    var label1Data = [String]()
    var label2Data = [String]()
    
    var scrollOffset : CGFloat = 0
    var distance : CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        AppManager.shared.saved = 0
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePicker1()
        createTimePicker1()
        createTimePicker2()
        
        sc.delegate = self
        sc.returnKeyType = .done
        
        well.delegate = self
        well.returnKeyType = .done
        
        note.delegate = self
        note.returnKeyType = .done
        
        date1TF.delegate = self
        time1TF.delegate = self
        time2TF.delegate = self
        
        if AppManager.shared.flag == 1 {
            let tempData = AppManager.shared.tableData[AppManager.shared.indexP] as [String: Any]
            print(tempData)
            let tempDate = tempData["date"] as! [String]
            date1TF.text = tempDate[0]
            
            let tempTime = tempData["time"] as! [String]
            time1TF.text = tempTime[0]
            time2TF.text = tempTime[1]
            
            let tempChecked = tempData["accept"] as! String
            if tempChecked == "1" {
                checkBtn.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
            }
            else {
                checkBtn.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
            }
            
            let tempLabel1 = tempData["label1"] as! [String]
            print(tempLabel1)
            label1Data = tempLabel1
            
            let tempLabel2 = tempData["label2"] as! [String]
            print(tempLabel2)
            label2Data = tempLabel2
            
            let tempSc = tempData["sc"] as! String
            sc.text = tempSc
            
            let tempWell = tempData["well"] as! String
            well.text = tempWell
            
            var temp = ""
            temp += "SC: " + sc.text! + " \"Enter\"\n"
            temp += "well: " + well.text! + " \"Enter\"\n"
            var tempLabel11 = ""
            for i in 0..<18 {
                tempLabel11 +=  tempLabel1[i] + " \"Enter\"\n"
            }
            temp += tempLabel11
            
            var tempLabel21 = ""
            for i in 0..<6 {
                tempLabel21 += tempLabel2[i] + " \"Enter\"\n"
            }
            temp += tempLabel21
            note.text = temp
        }
        else {
            for _ in 0..<18 {
                label1Data.append("")
            }
            for _ in 0..<6 {
                label2Data.append("")
            }
        }
        
//        AppManager.shared.tableData = [[String: Any]]()
//        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileUrl = documentDirectoryUrl.appendingPathComponent("Persons.json")
//
//        do {
//            let data = try JSONSerialization.data(withJSONObject: AppManager.shared.tableData, options: [])
//            try data.write(to: fileUrl, options: [])
//        } catch {
//            print(error)
//        }
        
        view1.layer.cornerRadius = 10
        view1.layer.masksToBounds = true
        view2.layer.cornerRadius = 10
        view2.layer.masksToBounds = true
        view3.layer.cornerRadius = 10
        view3.layer.masksToBounds = true
        view4.layer.cornerRadius = 10
        view4.layer.masksToBounds = true
        view5.layer.cornerRadius = 10
        view5.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        scrollView.endEditing(true)
        self.view1.endEditing(true)
        self.view2.endEditing(true)
        self.view3.endEditing(true)
        self.view4.endEditing(true)
        self.view5.endEditing(true)
        self.view6.endEditing(true)
        self.collectionView1.endEditing(true)
        self.collectionView2.endEditing(true)
    }

    @IBAction func saveData(_ sender: Any) {
        if AppManager.shared.saved == 0 {
            let date = [date1TF.text]
            let time = [time1TF.text, time2TF.text]
            let scString = sc.text
            let wellString = well.text
            let noteString = note.text
            var checked = "0"
            if checkBtn.currentImage == UIImage(named: "checked") {
                checked = "1"
            }
            var label1String = [String]()
            for i in 0..<18 {
                let cell = collectionView1.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell1
                label1String.append(cell.cv1TF.text!)
            }
            
            var label2String = [String]()
            for i in 0..<6 {
                let cell = collectionView2.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell2
                label2String.append(cell.cl2TF.text!)
            }
            
            let tempPerson = ["date": date, "time": time, "sc": scString, "well": wellString, "accept": checked, "label1": label1String, "label2": label2String, "note": noteString] as [String : Any]
            if AppManager.shared.flag == 1 {
                AppManager.shared.tableData[AppManager.shared.indexP] = tempPerson
            }
            else {
                AppManager.shared.tableData.append(tempPerson)
            }
            
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = documentDirectoryUrl.appendingPathComponent("Persons.json")
            print(fileUrl)

            do {
                let data = try JSONSerialization.data(withJSONObject: AppManager.shared.tableData, options: [])
                try data.write(to: fileUrl, options: [])
            } catch {
                print(error)
            }
            AppManager.shared.saved = 1
            
            var temp = ""
            temp += "SC: " + sc.text! + " \"Enter\"\n"
            temp += "well: " + well.text! + " \"Enter\"\n"
            var tempLabel1 = ""
            for i in 0..<18 {
                let cell = collectionView1.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell1
                tempLabel1 +=  cell.cv1TF.text! + " \"Enter\"\n"
            }
            temp += tempLabel1
            
            var tempLabel2 = ""
            for i in 0..<6 {
                let cell = collectionView2.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell2
                tempLabel2 += cell.cl2TF.text! + " \"Enter\"\n"
            }
            temp += tempLabel2
            note.text = temp
        }
        
        view.endEditing(true)
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return 18
        }
        else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell1", for: indexPath) as! CollectionViewCell1
            
            cell.cv1TF.text = label1Data[indexPath.row]
            cell.cv1TF.tag = indexPath.row + 6
            cell.cv1TF.delegate = self
            cell.cv1TF.returnKeyType = .done
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath) as! CollectionViewCell2
            
            cell.cl2TF.text = label2Data[indexPath.row]
            cell.cl2TF.tag = indexPath.row + 24
            cell.cl2TF.delegate = self
            cell.cl2TF.returnKeyType = .done
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1 {
            var width = self.view.frame.width - 40
            width = width / 3 - 10
            var height = self.collectionView1.frame.height
            height = height / 6 - 10
            return CGSize(width: width, height: height)
        }
        else {
            var width = self.collectionView2.frame.width
            width = width / 6 - 5
            return CGSize(width: width, height: 63)
        }
    }
}

extension DetailsViewController {
    func createDatePicker1() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(date1Done))
        toolbar.setItems([doneBtn], animated: true)
        
        date1TF.inputAccessoryView = toolbar
        date1TF.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    func createTimePicker1() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(time1Done))
        toolbar.setItems([doneBtn], animated: true)
        
        time1TF.inputAccessoryView = toolbar
        time1TF.inputView = datePicker1
        
        datePicker1.datePickerMode = .time
    }
    
    func createTimePicker2() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(time2Done))
        toolbar.setItems([doneBtn], animated: true)
        
        time2TF.inputAccessoryView = toolbar
        time2TF.inputView = datePicker1
        
        datePicker1.datePickerMode = .time
    }
    
    @objc func date1Done() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        date1TF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        sc.becomeFirstResponder()
    }
    
    @objc func time1Done() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        let date24 = formatter.string(from: datePicker1.date)
        
        time1TF.text = date24
        self.view.endEditing(true)
        time2TF.becomeFirstResponder()
    }
    
    @objc func time2Done() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        let date24 = formatter.string(from: datePicker1.date)
        
        time2TF.text = date24
        self.view.endEditing(true)
        let nextCell = self.collectionView1?.cellForItem(at: IndexPath.init(row: 0, section: 0))
        if let nextField = nextCell!.viewWithTag(6) as? UITextField {
            nextField.becomeFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        print("here")
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension DetailsViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField == sc { // Switch focus to other text field
            well.becomeFirstResponder()
        }
        else if textField == well {
            time1TF.becomeFirstResponder()
        }
        else {
            if textField.tag < 23 {
                let nextCell = self.collectionView1?.cellForItem(at: IndexPath.init(row: textField.tag - 5, section: 0))
                if let nextField = nextCell!.viewWithTag(textField.tag + 1) as? UITextField {
                    nextField.becomeFirstResponder()
                } else {
                    // Not found, so remove keyboard.
                    textField.resignFirstResponder()
                }
            }
            else if textField.tag < 29 {
                let nextCell = self.collectionView2?.cellForItem(at: IndexPath.init(row: textField.tag - 23, section: 0))
                if let nextField = nextCell!.viewWithTag(textField.tag + 1) as? UITextField {
                    nextField.becomeFirstResponder()
                } else {
                    // Not found, so remove keyboard.
                    textField.resignFirstResponder()
                }
            }
            else if textField.tag == 29 {
                note.becomeFirstResponder()
                var temp = ""
                temp += "SC: " + sc.text! + " \"Enter\"\n"
                temp += "well: " + well.text! + " \"Enter\"\n"
                var tempLabel1 = ""
                for i in 0..<18 {
                    let cell = collectionView1.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell1
                    tempLabel1 +=  cell.cv1TF.text! + " \"Enter\"\n"
                }
                temp += tempLabel1
                
                var tempLabel2 = ""
                for i in 0..<6 {
                    let cell = collectionView2.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell2
                    tempLabel2 += cell.cl2TF.text! + " \"Enter\"\n"
                }
                temp += tempLabel2
                note.text = temp
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag < 6 {
            print("===============")
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if textField.tag >= 6 && textField.tag < 24 {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.center.y+150), animated: true)
        }
        else if textField.tag >= 24 && textField.tag < 29 {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.center.y+180), animated: true)
        }
        else if textField.tag == 30 {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.center.y+300), animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.center.y+300), animated: true)
    }
}
