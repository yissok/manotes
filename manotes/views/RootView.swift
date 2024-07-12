import SwiftUI
import SwiftData

var startedFirstTime:Bool=false
struct RootView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var nodesGlobal: [TreeNode]
    
    @Query private var treeMeta: [TreeMetadata]
    
    var body: some View {
        
        
        func preStart() {
            if !startedFirstTime {
                print("started first time")
                startedFirstTime=true
                if treeMeta.count == 0 {
                    contextProvider.context!.insert(TreeMetadata(versionNumber: 0))
                    
                }
                
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
//        .onAppear(perform: start)
        .onOpenURL { (url) in
            //when being called by url from other app
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                print("foregr")
                pickUpShortcutNotes()
                pickLatestFileHistory()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
        
        
        func pickLatestFileHistory() {
            print("pickLatestFileHistory: ",treeMeta[0].versionNumber)
            
        }
        func pickUpShortcutNotes() {
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
                                handleShortcutInput(fileContent, nodesGlobal, contextProvider.context!)
                                try FileManager.default.removeItem(at: fileURL)
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

