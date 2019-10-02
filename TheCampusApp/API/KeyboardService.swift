import UIKit

public class KeyboardSize {
    private static var sharedInstance: KeyboardSize?
    private static var measuredSize: CGRect = CGRect.zero
    
    private var addedWindow: UIWindow
    private var textfield = UITextField()
    
    private var keyboardHeightKnownCallback: () -> Void = {}
    private var simulatorTimeout: Timer?
    
    public class func setup(_ callback: @escaping () -> Void) {
        guard measuredSize == CGRect.zero, sharedInstance == nil else {
            return
        }
        
        sharedInstance = KeyboardSize()
        sharedInstance?.keyboardHeightKnownCallback = callback
    }
    
    private init() {
        addedWindow = UIWindow(frame: UIScreen.main.bounds)
        addedWindow.rootViewController = UIViewController()
        addedWindow.addSubview(textfield)
        
        observeKeyboardNotifications()
        observeKeyboard()
    }
    
    public class func height() -> CGFloat {
        return measuredSize.height
    }
    
    private func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardChange), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func observeKeyboard() {
        let currentWindow = UIApplication.shared.keyWindow
        
        addedWindow.makeKeyAndVisible()
        textfield.becomeFirstResponder()
        
        currentWindow?.makeKeyAndVisible()
        
        setupTimeoutForSimulator()
    }
    
    @objc private func keyboardChange(_ notification: Notification) {
        textfield.resignFirstResponder()
        textfield.removeFromSuperview()
        
        guard KeyboardSize.measuredSize == CGRect.zero, let info = notification.userInfo,
            let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        
        saveKeyboardSize(value.cgRectValue)
    }
    
    private func saveKeyboardSize(_ size: CGRect) {
        cancelSimulatorTimeout()
        
        KeyboardSize.measuredSize = size
        keyboardHeightKnownCallback()
        
        KeyboardSize.sharedInstance = nil
    }
    
    private func setupTimeoutForSimulator() {
        if #available(iOS 10.0, *) {
            #if targetEnvironment(simulator)
            let timeout = 2.0
            simulatorTimeout = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { (_) in
                print(" KeyboardSize")
                print(" .keyboardDidShowNotification did not arrive after \(timeout) seconds.")
                print(" Please check \"Toogle Software Keyboard\" on the simulator (or press cmd+k in the simulator) and relauch your app.")
                print(" A keyboard height of 0 will be used by default.")
                self.saveKeyboardSize(CGRect.zero)
            })
            #endif
        }
    }
    
    private func cancelSimulatorTimeout() {
        simulatorTimeout?.invalidate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
