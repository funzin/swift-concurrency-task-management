## Overview
This is a repository that explains how to manage and cancel tasks.

## Environment
- Xcode 13.2

## Reference
I recommend you to read the following article to understand how to cancel tasks.
- [How to cancel a Task](https://www.hackingwithswift.com/quick-start/concurrency/how-to-cancel-a-task)

## Task issues
The following issues are related to Task.
- Even after the screen is dismissed, Task will continue to run.
- You have to write code to cancel tasks in a lot of files. It's boierplate code.

## Measures
1. Manage tasks in ViewModel
2. Cancel tasks when the screen is dismissed.

### 1. Manage tasks in ViewModel
The management method is similar to `Disposable` in RxSwift and `Cancellable` in Combine.<br>
Define ViewModel as BaseClass and then SubClass can be inherited it.

```swift
@MainActor
class ViewModel: ObservableObject, TaskCancellable {
    private var taskDict: [TaskID: [Task<Void, Never>]] = [:]
    
    deinit {
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
    }
}

// SubClass
final class FeatureAViewModel: ViewModel { }
```

### Cancel tasks when the screen is dismissed
If `viewWillDisappear` is called when the screen is poped or dismissed, tasks will be cancelled.<br>
This can be done by using `HostingViewController`.

```swift
@MainActor
class HostingViewController<Content: View, ViewModel: TaskCancellable>: UIHostingController<Content> {
    let viewModel: ViewModel

    init(rootView: Content, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let willDisappear = isBeingDismissed
        || isMovingFromParent
        || navigationController?.isBeingDismissed ?? false
        if willDisappear {
            viewModel.cancelAll()
        }
    }
}
```

## Demo
I use two screens to show the different behavior of canceling.

- FeatureA Screen: cancel all tasks when the screen is dismissed(Using `HostingViewController`)
- FeatureB Screen: not cancel all tasks when the screen is dismissed (Using `UIHostingControler`)

<details><summary>example code</summary><div>

```swift
final class FeatureAViewModel: ViewModel {
    func sleep() async -> Bool  {
        do {
            // wait 5 seconds
            try await Task.sleep(nanoseconds: 5000000000)
            return true
        } catch {
            return false
        }
    }
}

final class FeatureAViewController: HostingViewController<FeatureAView, FeatureAViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.addTask { [weak self] in
            let success = await self?.viewModel.sleep() ?? false
            
            // after waiting sleeping hours, print log
            print("success is \(success)")
        }
    }
}
final class FeatureBViewModel: ViewModel {
    func sleep() async -> Bool  {
        do {
            // wait 5 seconds
            try await Task.sleep(nanoseconds: 5000000000)
            return true
        } catch {
            return false
        }
    }
}

/// Use UIHostingController instead of HostingViewController
/// not cancel all tasks after screen is dismissed
final class FeatureBViewController: UIHostingController<FeatureBView> {
    private lazy var viewModel = FeatureBViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.addTask { [weak self] in
            let success = await self?.viewModel.sleep() ?? false
            
            // after waiting sleeping hours, print log
            print("success is \(success)")
        }
    }
}
```

</div></details>


### Behavior
#### viewDidLoad
Both screens print log in 5 seconds after `viewDidLoad` is called.
##### FeatureA

https://user-images.githubusercontent.com/12893657/154792749-af2d3e0a-9ef5-4ecd-bf57-aaac9303f618.mov

##### FeatureB

https://user-images.githubusercontent.com/12893657/154792753-7f0795ea-557b-423e-959b-380f977252bd.mov


#### Dismiss immediatly
If the screen is displayed and then dismissed immediately, the behavior will be different.
- FeatureA: cancel all tasks immediatly after the screen is dismissed.
- FeatureB: Tasks will continue to run even after the screen is dismissed.

##### FeatureA

https://user-images.githubusercontent.com/12893657/154792810-97ea3679-88c1-425f-a48f-b2f3c192b3ca.mov

##### FeatureB

https://user-images.githubusercontent.com/12893657/154792813-497b0256-e80c-4b0d-b7b5-3d079787002d.mov


## Conclusion
I have written about how to manage tasks using ViewModel.<br>
If you're interested, have a look at my project.

## Author
funzin

twitter: [@_funzin](https://twitter.com/_funzin)
