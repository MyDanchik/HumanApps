import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: SecondViewModel!

    private let tableView = UITableView()
    private var settingsItems: [String] = ["Об приложении - нажать чтобы внести"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingsItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            showAppInfoAlert()
        }
    }
    
    private func showAppInfoAlert() {
        let alert = UIAlertController(title: "Введите ваше имя и фамилию:", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Фамилия"
        }
        
        let submitAction = UIAlertAction(title: "Отправить", style: .default) { _ in
            if let firstName = alert.textFields?[0].text, let lastName = alert.textFields?[1].text {
                let fullName = "\(firstName) \(lastName)"
                self.settingsItems.append(fullName)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(submitAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
