//
//  ViewModel.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import Foundation

@MainActor
class ViewModel: ObservableObject, TaskCancellable {
    private var taskDict: [TaskID: [Task<Void, Never>]] = [:]
    
    init() {
        print("[\(type(of: self))]: init")
    }
    
    deinit {
        print("[\(type(of: self))]: deinit")
        taskDict.values.forEach { tasks in
            for task in tasks where !task.isCancelled {
                task.cancel()
            }
        }
    }
}

extension ViewModel {
    func addTask(
        priority: TaskPriority? = nil,
        operation: @Sendable @escaping () async -> Void
    ) {
        _addTask(id: DefaultTaskID(), task: Task(priority: priority, operation: operation))
    }
    
    func addTask<ID: TaskIDProtocol>(
        id: ID,
        priority: TaskPriority? = nil,
        operation: @Sendable @escaping () async -> Void
    ) {
        _addTask(id: id, task: Task(priority: priority, operation: operation))
    }
    
    func _addTask<ID: TaskIDProtocol>(
        id: ID,
        task: Task<Void, Never>
    ) {
        taskDict[id, default: []].append(task)
    }
    
    func cancelAll() {
        taskDict.values.forEach { tasks in
            for task in tasks where !task.isCancelled {
                task.cancel()
            }
        }
        taskDict = [:]
        print("[\(type(of: self))]: cancel all tasks")
    }
}
