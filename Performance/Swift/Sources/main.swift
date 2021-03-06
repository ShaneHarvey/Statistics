import MongoKitten
import Foundation

let startBench = Date()

func benchmark() throws -> Double {
    let start = Date()
    let db = try Database("mongodb://localhost:27017/compare")
    let users = db["users"]


    let documents = [Document](repeating: [
        "name_first": "Joannis",
        "name_last": "Orlandos",
        "age": 20,
        "programmer": true,
        "likes": [
            "mongodb", "swift", "programming", "swimming"
            ]
        ], count: 10_000)

    try users.insert(contentsOf: documents)

    let otherDocuments = [Document](repeating: [
        "name_first": "Harriebob",
        "name_last": "Narwhal",
        "age": 42,
        "programmer": false,
        "likes": [
            "facebook", "golfing", "cooking", "reading"
            ]
        ], count: 10_000)

    try users.insert(contentsOf: otherDocuments)

    var counter = 0

    for _ in try users.find("age" > 18) {
        counter += 1
    }

    var counter2 = 0

    for _ in try users.find("name_first" == "Joannis") {
        counter2 += 1
    }
    try users.remove([:])

    let end = Date()

    do {
        try db.server.disconnect()
    } catch {
        print("ERROR ON DISCONNECT \(error)")
    }
    let spent = end.timeIntervalSince(start)

    return spent

}

func prepare() throws {
    let db = try Database("mongodb://localhost:27017/compare")
    let users = db["users"]
    try users.remove([:])
    try db.server.disconnect()
}



func median(_ values: [Double]) -> Double? {
    let count = Double(values.count)
    if count == 0 { return nil }
    let sorted = values.sorted { $0 < $1 }

    if count.truncatingRemainder(dividingBy: 2) == 0 {
        let leftIndex = Int(count / 2 - 1)
        let leftValue = sorted[leftIndex]
        let rightValue = sorted[leftIndex + 1]
        return (leftValue + rightValue) / 2
    } else {
        return sorted[Int(count / 2)]
    }
}

try prepare()

var results = [Double]()

for _ in 0..<20 {
    results.append(try benchmark())
}

let endBench = Date()
let benchTotal = endBench.timeIntervalSince(startBench)

let max = results.reduce(0) { $0 > $1 ? $0 : $1 }
let min = results.reduce(max) { $0 < $1 ? $0 : $1 }
let average = results.reduce(0, +) / Double(results.count)

print("Max : \(max)")
print("Min : \(min)")
print("Average : \(average)")
if let median = median(results) {
    print("Median : \(median)")
}

print("Execution Time : \(benchTotal)")
print("Rounds : \(results.count)")

