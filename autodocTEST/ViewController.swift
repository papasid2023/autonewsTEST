import UIKit
import CoreData

class ViewController: UIViewController {
    var tableView = UITableView()
    var news: [postModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        title = "NEWS"
        getposts()
        setupTableView()
        
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(newsTableViewCell.self, forCellReuseIdentifier: newsTableViewCell.identifier)
    }

    private func getposts() {
        print("Fetching news...")

        let activity = UIActivityIndicatorView()
        view.addSubview(activity)
        activity.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        activity.color = .black
        activity.startAnimating()
        
            databaseManager.shared.getNews { [weak self] posts in
                self?.news = posts
                print("Found \(posts.count) posts")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    activity.stopAnimating()
                }
            }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = news[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCell.identifier, for: indexPath) as? newsTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(imageURL: URL(string: post.titleImageUrl ?? "unknown"), title: post.title ?? "unknown"))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let new = news[indexPath.row]

        let vc = NewsViewController(news: new)
        vc.title = "news"

        navigationController?.pushViewController(vc, animated: true)
    }
}
