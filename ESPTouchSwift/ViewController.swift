import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController, ESPTouchControllerDelegate {
    
    var espController = ESPTouchController()
    func handleConnectionTimeoutAlert(resultCount:Int){
        if(resultCount == 0 ){
            if let ok = self.okAction{
                ok.isEnabled = true
            }
            self.alertController.title = "Connection Timeout"
            self.alertController.message = "no devices found, check if your ESP is in Connection mode!"
        }
    }
    func handleAddedResult(resultCount:Int, bssid: String!, ip:String!){
        if(resultCount >= self.resultExpected ){ //bug on condition, must know why!
            espController.interruptESP();
            if let ok = self.okAction{
                ok.isEnabled = true
            }
        }
        if(resultCount >= 1 ){
            self.resultCount = self.resultCount + 1
            self.alertController.title = "\(self.resultCount) ESP\(self.resultCount > 1 ? "(s)" :" ") connected"
            self.messageResult  += "\(String(describing: bssid)) - ip: \(String(describing: ip))\n";
            self.alertController.message = self.messageResult;
        }
    }
    
    var resultExpected = 0
    var alertController = UIAlertController()
    var messageResult = ""
    var resultCount = 0
    var okAction:UIAlertAction?
    var bssid: String?
    
    @IBOutlet var numberOfDevicesLabel: UILabel!
    @IBOutlet var passwordInputText: UITextField!
    @IBOutlet var ssidInputText: UITextField!
    @IBOutlet var isHiddenSwitch: UISwitch!
    
    @IBAction func onNumberDevicesChange(_ sender: UISlider) {
        resultExpected = Int(sender.value)
        numberOfDevicesLabel.text = resultExpected == 0 ? "All" : resultExpected.description
    }
    
    @IBAction func onChangeIsHidden(_ sender: Any) {
        if(self.isHiddenSwitch.isOn){
            self.ssidInputText.isUserInteractionEnabled = true;
            self.ssidInputText.borderStyle =  UITextBorderStyle.roundedRect;
        }
        else {
            self.ssidInputText.isUserInteractionEnabled = false;
            self.ssidInputText.borderStyle =  UITextBorderStyle.none;
        }
    }
    

    @IBAction func send(_ sender: UIButton) {
        if  self.ssidInputText.text?.compare("Not Connected to Wifi").rawValue != 0{
            self.espController.delegate = self;
            self.showAlertWithResult(title:"Connetting...",message:"");
            self.espController.sendSmartConfig(bssid: self.bssid!, ssid: self.ssidInputText.text!, password: self.passwordInputText.text!, resultExpected: Int32(self.resultExpected));
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHiddenSwitch.setOn(false, animated: true);
        self.ssidInputText.isUserInteractionEnabled = false;
        self.ssidInputText.borderStyle =  UITextBorderStyle.none;
        self.hideKeyboardWhenTappedAround() ;
    }
   
    func showAlertWithResult(title : String,  message: String){
        
        alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: {
            action in self.espController.interruptESP()
        }))
        
        self.okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil)
        if let ok = self.okAction {
            ok.isEnabled = false
            alertController.addAction(ok)
        }
        self.present(alertController, animated: true, completion: nil)
    
    }
}

