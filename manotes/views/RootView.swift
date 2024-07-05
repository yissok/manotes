import SwiftUI
import SwiftData

var firstInit:Bool=false
struct RootView: View {
    
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var nodesGlobal: [TreeNode]
    
    var body: some View {
        
        
        func preStart() {
            if !firstInit {
                print("pre started main view")
                firstInit=true
            }
        }
        
        func initRoot() -> TreeNode {
            let rootList: [TreeNode]=nodesGlobal.filter({ $0.name == LB_ROOT })
            if rootList.isEmpty {
                let root = TreeNode(content: nil, name: LB_ROOT, parent: nil)
                contextProvider.context!.insert(root)
                return root
            } else {
                return nodesGlobal.filter({ $0.name == LB_ROOT }).first!
            }
        }
        preStart()
        let root = initRoot()
        return NavigationStack{
            VStack{
                ItemList(nodesGlobal: nodesGlobal, parent: root)
            }
            
        }
        .onAppear(perform: start)
        .onOpenURL { (url) in
            handleShortcutInput(url, nodesGlobal, contextProvider.context!)
        }
        
        
        func start() {
            print("started main view")
            
            if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                
                let fileURL = iCloudURL.appendingPathComponent(".test")

                try? "".data(using: .utf8)?.write(to: fileURL)
                // List all files in the directory
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: nil)
                    // Print the file URLs or do something with them
                    for fileURL in fileURLs {
                        print("Found file: \(fileURL)")
                        // Here you can read the file content if needed
                        // For example, let's read the content of a text file
                        if fileURL.pathExtension == "txt" {
                            if let fileContent = try? String(contentsOf: fileURL, encoding: .utf8) {
                                print("File content: \(fileContent)")
                            }
                        }
                    }
                } catch {
                    print("Error while enumerating files \(iCloudURL.path): \(error.localizedDescription)")
                }
            } else {
                print("iCloud is not available or not configured properly")
            }
        }
    }
}

