import UIKit

class TaskEditController: UITableViewController {
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?

    private var taskTitles: [TaskPriority:String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]

    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    @IBOutlet var taskStatusSwitch: UISwitch!

    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let title = (taskTitle?.text ?? "").trimmingCharacters(in: .whitespaces)
        if title.isEmpty {
            let alertController = UIAlertController(
                title: "Ошибка",
                message: "Введите описание задачи",
                preferredStyle: .alert)
            let confirmAction = UIAlertAction(
                title: "Повторить", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let type = taskType
            let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
            doAfterEdit?(title, type, status)
            navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle?.text = taskText
        taskTypeLabel?.text = taskTitles[taskType]
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            let destination = segue.destination as! TaskTypeController
            destination.selectedType = taskType
            destination.doAfterTypeSelected = { [unowned self ] selectedType in
                taskType = selectedType
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
