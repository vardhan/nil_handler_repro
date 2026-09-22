import Cocoa
import FlutterMacOS

/// this owns the standard Flutter view and the native setup channel for its lifetime.
class MainFlutterWindow: NSWindow {
  private var controlChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let controller = FlutterViewController()
    let windowFrame = frame
    contentViewController = controller
    setFrame(windowFrame, display: true)
    RegisterGeneratedPlugins(registry: controller)

    let messenger = controller.engine.binaryMessenger
    let channel = FlutterMethodChannel(name: "repro/control", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak controller] call, result in
      guard call.method == "unregister" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard let controller = controller else { return }
      precondition(Thread.isMainThread)
      let messenger = controller.engine.binaryMessenger
      messenger.setMessageHandlerOnChannel("repro/nil-handler", binaryMessageHandler: { _, reply in
        reply(nil)
      })

      // This is the documented unregister API, imported directly into Swift.
      messenger.setMessageHandlerOnChannel("repro/nil-handler", binaryMessageHandler: nil)
      NSLog("REPRO: registered then unregistered handler on main thread")
      result(nil)
    }
    controlChannel = channel
    super.awakeFromNib()
  }
}
