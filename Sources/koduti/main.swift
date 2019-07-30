import Foundation
import SwiftShell

let env = ProcessInfo().environment
let args = Array(ProcessInfo().arguments.dropFirst())

if let debugPath = env["WorkingDirectory"] {
    main.currentdirectory = debugPath
}

do {
    guard let cmdString = args.first
        , let cmd = KodutiCommands(rawValue: cmdString) else
    {
        throw ServiceError.argumentIsMissing("Please type like \"koduti XXXX\"")
    }
    
    let options = Array(args.dropFirst())
    
    switch cmd {
    case .initialize:
        try Initializer(args: options).execute()
        
    case .generate:
        let yaml = try YamlLoader.loadYamlIfPossible()
        let argument = ArgumentReader(args: options)
        var generater = Generator(argument: argument, yaml: yaml)
        try generater.execute()
    }
    
} catch let e as ServiceError {
    print("ServiceError \(e) description: \(e.errorDescription())")
    exit(1)
    
} catch let e as NSError {
    print("SystemError \(e) description: \(e.localizedDescription)")
    exit(2)
    
} catch {
    print("unknown error")
    exit(3)
}

exit(0)

