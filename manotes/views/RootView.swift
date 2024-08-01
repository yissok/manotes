import SwiftUI
import SwiftData
import CommonCrypto


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
//                removeEverything()
                removeEverythingNotConnectedToRoot()
                removeHeadlessNodes()
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
        return NavigationView{
            VStack{
                HStack{
                    Text(String(versionNumber!))
                    Button{
                        versionNumber=0
                        deleteAllHistory()
                    } label: {
                        Image(systemName: "delete.left")
                    }
                    .foregroundColor(Color.yellow)
                    Button{
                        removeEverything()
                    } label: {
                        Image(systemName: "eraser.fill")
                    }
                    .foregroundColor(Color.yellow)
                }
                ItemList(nodesGlobal: nodesGlobal, parent: root)
                ScrollView {
                    VStack {
                        Text(getFile() ?? "na")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
        func getFile() -> String? {
            guard let url = Bundle.main.url(forResource: "TODO", withExtension: "md") else { return nil }
            return try? String(contentsOf: url, encoding: .utf8)
        }
        
        func pickLatestFileHistory() {
            print("pickLatestFileHistory: ",versionNumber)
            
        }
        

        func removeEverything() {
            print("removeEverythingNotConnectedToRoot: ")
            nodesGlobal.forEach { item in
                deleteItem(item, contextProvider.context!)
            }
            initRoot()
        }

        func removeEverythingNotConnectedToRoot() {
            print("removeEverythingNotConnectedToRoot: ")
            nodesGlobal.filter { $0.parent==nil &&  $0.name != LB_ROOT }.forEach { item in
                deleteTag(item, contextProvider.context!)
            }
//            nodesGlobal.filter {$0.name == "bb" }.forEach { item in
//                deleteTag(item, contextProvider.context!)
//            }
        }
        
        func removeHeadlessNodes() {
            print("removeHeadlessNodes: ")
            nodesGlobal.filter { $0.parent==nil &&  $0.name=="" }.forEach { item in
                contextProvider.context!.delete(item)
            }
        }
        func pickUpShortcutNotes() {
            print("started main view")
            do {
                try createHistoryIfNotExist()
            } catch let error {
                print(error.localizedDescription)
            }
            
            if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: nil)
                    for fileURL in fileURLs {
                        print("File fileURL: \(fileURL)")
                        if fileURL.pathExtension == "txt" {
                            if let fileContent = try? String(contentsOf: fileURL, encoding: .utf8) {
                                print("File content: \(fileContent)")
                                handleShortcutInput(fileContent, nodesGlobal, contextProvider.context!, noteDate: extractFilenameWithoutExtension(from: fileURL.absoluteString)!)
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
        func extractFilenameWithoutExtension(from urlString: String) -> String? {
            // Regular expression pattern to match the filename without the extension
            let pattern = ".*/([^/]+)\\.txt$"

            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let nsString = urlString as NSString
                let results = regex.matches(in: urlString, options: [], range: NSRange(location: 0, length: nsString.length))
                
                if let match = results.first {
                    let filenameWithoutExtension = nsString.substring(with: match.range(at: 1))
                    return filenameWithoutExtension
                } else {
                    return nil
                }
            } catch {
                print("Invalid regex: \(error.localizedDescription)")
                return nil
            }
        }
        
        func deleteAllHistory() {
            if let iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents/history") {
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: iCloudURL, includingPropertiesForKeys: nil)
                    for fileURL in fileURLs {
                        try FileManager.default.removeItem(at: fileURL)
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

