import Cocoa
import FlutterMacOS
import UserNotifications

public class SupaArchitecturePlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "supa_architecture", binaryMessenger: registrar.messenger)
    let instance = SupaArchitecturePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Set notification delegate
    UNUserNotificationCenter.current().delegate = instance
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestNotificationPermission":
      requestNotificationPermission(result: result)
    case "sendNotification":
      guard let args = call.arguments as? [String: String],
            let title = args["title"],
            let body = args["body"] else {
        result(FlutterError(code: "INVALID_ARGUMENTS",
                            message: "Missing title or body arguments",
                            details: nil))
        return
      }
      sendNotification(title: title, body: body, result: result)
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestNotificationPermission(result: @escaping FlutterResult) {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        result(FlutterError(code: "NOTIFICATION_PERMISSION_ERROR",
                            message: "Failed to request notification permissions",
                            details: error.localizedDescription))
      } else {
        result(granted)
      }
    }
  }

  private func sendNotification(title: String, body: String, result: @escaping FlutterResult) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        result(FlutterError(code: "NOTIFICATION_ERROR",
                            message: "Failed to send notification",
                            details: error.localizedDescription))
      } else {
        result(nil)
      }
    }
  }
}
