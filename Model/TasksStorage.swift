import Foundation

protocol TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}

class TasksStorage: TasksStorageProtocol {
    var storageKey: String = "tasks"
    private var storage = UserDefaults.standard

    private enum TaskKey: String {
        case title
        case type
        case status
    }

    func loadTasks() -> [TaskProtocol] {
        var resultTasks: [TaskProtocol] = []
        let tasksFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for task in tasksFromStorage {
            guard let title = task[TaskKey.title.rawValue],
                  let typeRaw = task[TaskKey.type.rawValue],
                  let statusRaw = task[TaskKey.status.rawValue] else {
                continue
            }
            var type: TaskPriority
            if typeRaw == "important" {
                type = .important
            } else if typeRaw == "normal" {
                type = .normal
            } else {
                type = .backlog
            }
            let status: TaskStatus = (statusRaw == "planned") ? .planned : .completed
            resultTasks.append(Task(title: title, type: type, status: status))
        }
        return resultTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        var arrayForStorage: [[String:String]] = []
        tasks.forEach { task in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            if task.type == .important {
                newElementForStorage[TaskKey.type.rawValue] = "important"
            } else if task.type == .normal {
                newElementForStorage[TaskKey.type.rawValue] = "normal"
            } else {
                newElementForStorage[TaskKey.type.rawValue] = "backlog"
            }
            newElementForStorage[TaskKey.status.rawValue] = (task.status == .planned) ? "planned" : "completed"
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
