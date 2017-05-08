//
//  ViewController.swift
//  Assignment2
//
//  Created by Darshan Patil on 10/4/16.
//  Copyright © 2016 Darshan Patil. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITextFieldDelegate {
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }

    // input variables
    @IBOutlet weak var billAmount: UITextField!             //text field for textfield to enter bill amount
    @IBOutlet weak var tipPercentageSlider: UISlider!       //slider for tip percentage
    @IBOutlet weak var partySizeSlider: UISlider!           //slider for number of people the total amount should be split in
    // output
    @IBOutlet weak var tipPercentageLabel: UILabel!         //label to display when the tip slider is changed
    @IBOutlet weak var totalBillAmount: UILabel!            //label to display the total amount based on bill amount and tip percent
    @IBOutlet weak var partySizeLabel: UILabel!             //label to display size of the party
    @IBOutlet weak var individualAmount: UILabel!           //label to display individual share amount from the total bill
    
    //storing the values entered in the input fields into local variables
    var totalAmount = 0.0                                   //variable to store total bill amount after adding tip and amoun entered   in textfield
    var tipLabel = 20                                       //variable to store default tip percentage
    var partyLabel = 1                                      //variable to store default party size
    var shareAmount = 0.0                                   //variable to store individual share amount
    var tipPercent: CGFloat = 20                            //variable to store tip percentage slider value; set to 20 default
    var partySize: CGFloat = 1                              //variable to store party size slider value; set to 1 default
    var initialBillAmount: Double = 0.0 {                   //variable to store bill amount entered by user
        didSet{                                             //didset property observer
            configureView()                                 //function invoked whenever the initialBillAmount value is changed
        }
    }
    
    @IBAction func tipSlider(sender: UISlider) {            //action for sliders
        
        if sender == tipPercentageSlider {                  //condition to check which slider has triggered the event
            tipPercent = CGFloat(sender.value)              //storing the sender value in a variable
            tipLabel = Int(tipPercent)                      //converting the sender store variable to int and storing it in other varialbe to use for future calculations
            tipLabel = tipLabel * 5                         //multiplying the tip by 5 and storing it in again
            tipPercentageLabel.text = String(tipLabel) + "%"    //assigning the tip value from above step to label
            configureView()                                 //function call to do other calculations
            
       }else if sender == partySizeSlider {                 //condition to check which slider has triggered the event
            partySize = CGFloat(sender.value)               //storing the sender value in a variable
            partyLabel = Int(partySize)                     //converting the sender store variable to int and storing it in other varialbe to use for future calculations
            partySizeLabel.text = String(partyLabel)        //assigning the party size value from above step to label
            configureView()                                 //function call to do other calculations
        }
    }
    
    func configureView() {                                                      //function to do total bill amount calculation and individual share amount calculation
        let formatter = NSNumberFormatter()                                     //using number formatter to format output values to currency
        formatter.locale = NSLocale.currentLocale()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        let tip = Double(tipLabel) / 100                                        //converting the tip from percentage to double
        totalAmount = initialBillAmount + (initialBillAmount * tip)             //calculating the total amount by adding tip and initial amount
        let formatted_totalAmount = formatter.stringFromNumber(totalAmount)!    //variable to store formatted values
        totalBillAmount.text = String(formatted_totalAmount)                    //displaying the calculated amounts to respective output label
        
        let share = Double(partyLabel)                                          //converting the party size from percentage to double
        shareAmount = totalAmount / share                                       //calculating the individual share
        let formatted_shareAmount = formatter.stringFromNumber(shareAmount)!    //variable to store formatted values
        individualAmount.text = String(formatted_shareAmount)                   //displaying the calculated amounts to respective output text label
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.billAmount.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        if billAmount.text!.isEmpty{                                                //checking for empty value to avoid errors
            initialBillAmount = 0.00                                                //setting default value if text field empty
        }else {
            initialBillAmount = Double(billAmount.text!)!                           //updating the initialBillAmount on each touchesBegan
        }
  
    }

    //function to check/avoid extra dots in input fields
    func textField(textField: UITextField,shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool
    {
        textField.delegate = self
        
        let countdots = textField.text!.componentsSeparatedByString(".").count - 1
        
        if countdots > 0 && string == "." {
            return false
        }
        return true
    }
}