import SwiftUI
import SwiftData

var startedFirstTime:Bool=false
struct RootView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var contextProvider: ContextProvider
    @Query private var nodesGlobal: [TreeNode]
    @AppStorage(UD_VERSION_NUMBER) private var versionNumber:Int?

    var body: some View {
        
        
        func preStart() {
            if !startedFirstTime {
                print("started first time")
                startedFirstTime=true
                if versionNumber == nil {
                    versionNumber=0
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
            print("pickLatestFileHistory: ",versionNumber)
            
        }
        func pickUpShortcutNotes() {
            print("started main view")
            do {
                try writeToFile(input: "", path: ".test")
            } catch let error {
                print(error.localizedDescription)
            }
            
            if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: nil)
                    for fileURL in fileURLs {
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

