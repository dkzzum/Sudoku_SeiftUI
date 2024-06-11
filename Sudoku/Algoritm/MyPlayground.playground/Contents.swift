import Foundation

func measureExecutionTime(iterations: Int) -> TimeInterval {
    let startTime = Date()
    let grid = Grid(len_area: 3)
    grid.generation(repetitions: iterations)
    let endTime = Date()
    return endTime.timeIntervalSince(startTime)
}

let iterationCounts = [10, 20, 50, 100, 500, 1000]
var executionTimes: [TimeInterval] = []

for count in iterationCounts {
    let executionTime = measureExecutionTime(iterations: count)
    executionTimes.append(executionTime)
    print("Iterations: \(count), Time: \(executionTime) seconds")
}
