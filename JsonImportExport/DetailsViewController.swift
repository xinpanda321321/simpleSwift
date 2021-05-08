//
//  DetailsViewController.swift
//  JsonImportExport
//
//  Created by sinpanda on 5/7/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var date1TF: UITextField!
    @IBOutlet weak var date2TF: UITextField!
    @IBOutlet weak var time1TF: UITextField!
    @IBOutlet weak var time2TF: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var note: UITextView!
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createDatePicker1()
        createDatePicker2()
        createTimePicker1()
        createTimePicker2()
    }

    @IBAction func saveData(_ sender: Any) {
        let date = [date1TF.text, date2TF.text]
        let time = [time1TF.text, time2TF.text]
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
        
        let label2String = [String]()
        for i in 0..<6 {
            let cell = collectionView2.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell2
            label1String.append(cell.cl2TF.text!)
        }
        
        let tempPerson = ["date": date, "time": time, "accept": checked, "label1": label1String, "label2": label2String, "note": noteString] as [String : Any]
        AppManager.shared.tableData.append(tempPerson)
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Persons.json")

        do {
            let data = try JSONSerialization.data(withJSONObject: AppManager.shared.tableData, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
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
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath) as! CollectionViewCell2
            
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
    
    func createDatePicker2() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(date2Done))
        toolbar.setItems([doneBtn], animated: true)
        
        date2TF.inputAccessoryView = toolbar
        date2TF.inputView = datePicker
        
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
    }
    
    @objc func date2Done() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        date2TF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func time1Done() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        
        time1TF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func time2Done() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        
        time2TF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
