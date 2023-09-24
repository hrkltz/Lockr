import UIKit
import Flutter
import ZipArchive


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                                  binaryMessenger: controller.binaryMessenger)
        let containerChannel = FlutterMethodChannel(name: "container",
                                                     binaryMessenger: controller.binaryMessenger)
        
        containerChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            switch call.method {
                case "create":
                    print("container/create")
                    // Arguments:
                    //   containerLabel
                    //   locationPath
                    //   password
                    // 1. Export an empty zip file to the public document folder
                    let arguments = (call.arguments as! Dictionary<String, Any>)
                    let containerLabel = arguments["containerLabel"] as! String
                    // TODO: Use .tmpDirectory? See https://byby.dev/ios-persistence.
                    let documentUrl: URL = try! FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true)
                    let fileUrl = documentUrl.appendingPathComponent("HelloWorld.txt")
                    SSZipArchive.createZipFile(
                        atPath: documentUrl.appendingPathComponent("\(containerLabel).zip").path,
                        withFilesAtPaths: [/*fileUrl.path*/],
                        withPassword: "test")
                    // Add the full path of this ZIP archive to UserDefaults. See https://byby.dev/ios-persistence.
                    result(true)
                    return;
                case "list":
                    print("container/list")
                    let containerPathArray = UserDefaults.standard.object(forKey: "ContainerPathArray") as? [String] ?? [String]()
                    // TODO: Map containerPathArray to containerLabelArray ()
                    let containerLabelArray = containerPathArray
                    result(containerLabelArray)
                    return;
                break;
                case "delete":
                    print("container/delete")
                    // Arguments
                    //   containerLabel
                    //   password? Technical the file can always be deleted without password via filemanager.
                    return;
                default:
                    result(FlutterMethodNotImplemented)
                    return

            }
            
            /*
            let arguments = (call.arguments as! Dictionary<String, Any>)
            let containerLabel = arguments["containerLabel"] as! String
            
            let documentUrl: URL = try! FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
            
            let fileUrl = documentUrl.appendingPathComponent("HelloWorld.txt")
            let zipUrl = documentUrl.appendingPathComponent("\(containerLabel).zip")
            var content: String = ""
            _ = self?.write(fileUrl: fileUrl, content: "Hello World!!!")
            _ = self?.read(fileUrl: fileUrl, content: &content)
            _ = self?.list(pathUrl: documentUrl)
            SSZipArchive.createZipFile(atPath: zipUrl.path, withFilesAtPaths: [fileUrl.path], withPassword: "test")
            _ = self?.delete(fileUrl: fileUrl)
            _ = self?.list(pathUrl: documentUrl)
            _ = self?.unzip(zipUrl: zipUrl, destinationUrl: documentUrl, password: "test1")
            _ = self?.delete(fileUrl: zipUrl)
            _ = self?.list(pathUrl: documentUrl)*/
        })
        
        batteryChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          // This method is invoked on the UI thread.
          guard call.method == "getBatteryLevel" else {
            result(FlutterMethodNotImplemented)
            return
          }
            let documentUrl: URL = try! FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
            
            let fileUrl = documentUrl.appendingPathComponent("HelloWorld.txt")
            let zipUrl = documentUrl.appendingPathComponent("helloWorld.zip")
            var content: String = ""
            _ = self?.write(fileUrl: fileUrl, content: "Hello World!!!")
            _ = self?.read(fileUrl: fileUrl, content: &content)
            _ = self?.list(pathUrl: documentUrl)
            SSZipArchive.createZipFile(atPath: zipUrl.path, withFilesAtPaths: [fileUrl.path], withPassword: "test")
            _ = self?.delete(fileUrl: fileUrl)
            _ = self?.list(pathUrl: documentUrl)
            _ = self?.unzip(zipUrl: zipUrl, destinationUrl: documentUrl, password: "test1")
            _ = self?.delete(fileUrl: zipUrl)
            _ = self?.list(pathUrl: documentUrl)
            
          self?.receiveBatteryLevel(result: result)
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    private func unzip(zipUrl: URL, destinationUrl: URL, password: String) -> Bool {
        print("unzip(..)")
        
        do {
            try SSZipArchive.unzipFile(
                atPath: zipUrl.path,
                toDestination: destinationUrl.path,
                overwrite: false,
                password: password)
        } catch let error as NSError {
            print(error)
            return false
        }
        
        return true;
    }
    
    private func documentDirectory() -> URL {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return URL(string: documentDirectory[0])!
    }


    private func write(fileUrl: URL, content: String) -> Bool {
        print("write(..)")
        
        do {
            try content.write(
                to: fileUrl,
                atomically: true,
                encoding: .utf8)
        } catch let error as NSError {
            print(error)
            return false
        }
        
        return true;
    }
    
    
    private func read(fileUrl: URL, content: inout String) -> Bool {
        print("read(..)")
        
        do {
            content = try String(contentsOf: fileUrl)
            print("> \(content)")
        } catch let error as NSError {
            print(error)
            return false
        }

        return true
    }
    
    
    private func delete(fileUrl: URL) -> Bool {
        print("delete(..)")
        
        do {
            try FileManager.default.removeItem(at: fileUrl)
        } catch let error as NSError {
            print(error)
            return false
        }
        
        return true
    }
    
    
    private func list(pathUrl: URL) -> Bool {
        print("list(..)")
        
        do {
            let itemArray = try FileManager.default.contentsOfDirectory(
                at: pathUrl,
                includingPropertiesForKeys: nil)
            
            for item in itemArray {
                print("> \(item.lastPathComponent)")
            }
        } catch let error as NSError {
            print(error)
            return false
        }
        
        return true
    }
    


  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == UIDevice.BatteryState.unknown {
      result(FlutterError(code: "UNAVAILABLE",
                          message: "Battery level not available.",
                          details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }
}


