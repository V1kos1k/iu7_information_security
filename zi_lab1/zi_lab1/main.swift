//
//  main.swift
//  zi_lab1
//
//  Created by Mkhitaryan Viktoriya on 03/10/2019.
//  Copyright © 2019 Mkhitaryan Victoria. All rights reserved.
//

import Foundation
import CryptoSwift

func readFile() -> String {
    let file = "file.key" //this is the file. we will write to and read from it
    var text: String = ""

    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        //print(type(of: fileURL))
        do {
            text = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
    return text // нужно возвращать не имя файла в его содержмое
}

func writeToFile(lsWithArgumentsOutput: Substring) {
    let file = "file.key"
    let text = String(lsWithArgumentsOutput).sha256()
    //print(text)

    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
}

func installer() {
    let bash: CommandExecuting = Bash()
    let lsWithArgumentsOutput = bash.execute(commandName: "system_profiler", arguments: ["SPHardwareDataType", "| awk '/UUID/ { print $3; }'"])!.split(separator: " ").last!.split(separator: "\n").first!

    //print(type(of: lsWithArgumentsOutput))
    //print(lsWithArgumentsOutput)
    writeToFile(lsWithArgumentsOutput: lsWithArgumentsOutput)
    
    print("Ключ обновлен.")
}


func run() {
    let bash: CommandExecuting = Bash()
    let lsWithArgumentsOutput = bash.execute(commandName: "system_profiler", arguments: ["SPHardwareDataType", "| awk '/UUID/ { print $3; }'"])!.split(separator: " ").last!.split(separator: "\n").first!

    //print(type(of: lsWithArgumentsOutput))
    
    let key = readFile()
    
    if key == String(lsWithArgumentsOutput).sha256() {
        print("OK")
    } else {
        print("ERROR")
    }
}


// надо бы добавтиь кодировку, ноооооо... не сейчас
run()
//installer()

