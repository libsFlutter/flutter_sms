import Flutter
import UIKit
import MessageUI

public class FlutterSmsussdPlugin: NSObject, FlutterPlugin, MFMessageComposeViewControllerDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_smsussd", binaryMessenger: registrar.messenger())
    let instance = FlutterSmsussdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private var result: FlutterResult?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      
    case "sendSms":
      let phoneNumber = call.arguments as? [String: Any]
      let number = phoneNumber?["phoneNumber"] as? String
      let message = phoneNumber?["message"] as? String
      
      if let number = number, let message = message {
        sendSms(phoneNumber: number, message: message, result: result)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", 
                          message: "Phone number and message are required", 
                          details: nil))
      }
      
    case "getSmsMessages":
      result(FlutterError(code: "NOT_SUPPORTED", 
                         message: "Reading SMS messages is not supported on iOS due to Apple's restrictions", 
                         details: nil))
      
    case "getSmsMessagesByPhoneNumber":
      result(FlutterError(code: "NOT_SUPPORTED", 
                         message: "Reading SMS messages is not supported on iOS due to Apple's restrictions", 
                         details: nil))
      
    case "requestSmsPermissions":
      // iOS doesn't require special permissions for opening SMS composer
      result(true)
      
    case "hasSmsPermissions":
      // iOS doesn't require special permissions for opening SMS composer
      result(true)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func sendSms(phoneNumber: String, message: String, result: @escaping FlutterResult) {
    if MFMessageComposeViewController.canSendText() {
      self.result = result
      
      let messageController = MFMessageComposeViewController()
      messageController.messageComposeDelegate = self
      messageController.recipients = [phoneNumber]
      messageController.body = message
      
      if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        rootViewController.present(messageController, animated: true, completion: nil)
      } else {
        result(FlutterError(code: "NO_VIEW_CONTROLLER", 
                           message: "No view controller available to present SMS composer", 
                           details: nil))
      }
    } else {
      result(FlutterError(code: "SMS_NOT_AVAILABLE", 
                         message: "SMS is not available on this device", 
                         details: nil))
    }
  }
  
  // MARK: - MFMessageComposeViewControllerDelegate
  
  public func messageComposeViewController(_ controller: MFMessageComposeViewController, 
                                         didFinishWith result: MessageComposeResult) {
    controller.dismiss(animated: true) {
      switch result {
      case .cancelled:
        self.result?(false)
      case .failed:
        self.result?(FlutterError(code: "SMS_SEND_ERROR", 
                                 message: "Failed to send SMS", 
                                 details: nil))
      case .sent:
        self.result?(true)
      @unknown default:
        self.result?(false)
      }
    }
  }
}
