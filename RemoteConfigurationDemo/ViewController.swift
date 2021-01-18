//
//  ViewController.swift
//  RemoteConfigurationDemo
//
//  Created by Pinto Diaz, Roger on 1/18/21.
//

import Kingfisher
import UIKit

final class ViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var btnLoadRemoteContent: UIButton!

    // MARK: - Properties

    var data: Data?
    let remoteUrl = "" // Set your firebase storage remote URL
    let imageUrl = "https://upload.wikimedia.org/wikipedia/en/thumb/1/16/Sage_logo.svg/1200px-Sage_logo.svg.png"
    let containerViewTag: Int = 0

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let remoteView = configureRemoteView()
        uploadRemoteView(remoteView)
    }

    // MARK: - onButton actions

    @IBAction func onLoadRemoteContent(_ sender: UIButton) {
        DataService.instance.getRemoteData { (data) in
            do {
                let remoteView = try PropertyListDecoder().decode(RemoteView.self, from: data)

                DispatchQueue.main.async {
                    self.addRemoteView(remoteView)
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Support methods

    private func addRemoteView(_ remoteView: RemoteView) {
        let mainView = NSKeyedUnarchiver.unarchiveObject(with: remoteView.data) as! UIView
        view.addSubview(mainView)

        for relationship in remoteView.relationships {
            if let parentView = relationship.parent == containerViewTag ? view : mainView.viewWithTag(relationship.parent),
               let childView = mainView.viewWithTag(relationship.child) {

                let constraints = relationship.constraints
                childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: constraints.top).isActive = true
                childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constraints.bottom).isActive = true
                childView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: constraints.left).isActive = true
                childView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: constraints.right).isActive = true

                if let remoteImageUrl = relationship.imageUrl, let imageView = childView as? UIImageView {
                    imageView.kf.setImage(with: URL(string: remoteImageUrl))
                }

                if relationship.hasShadow {
                    childView.shadow()
                    childView.roundedCorners()
                }
            }
        }
    }

    private func configureRemoteView() -> UIView {
        let image = UIImageView()
        image.tag = 4
        image.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Loaded a remote view"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.tag = 1234
        label.translatesAutoresizingMaskIntoConstraints = false

        let vRemote = UIView()
        vRemote.backgroundColor = .white
        vRemote.layer.cornerRadius = 5
        vRemote.tag = 1
        vRemote.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        vRemote.addSubview(image)
        vRemote.addSubview(label)

        return vRemote
    }

    private func uploadRemoteView(_ remoteView: UIView) {
        do {
            let archiveView = try NSKeyedArchiver.archivedData(withRootObject: remoteView, requiringSecureCoding: false)
            let remoteView = RemoteView(data: archiveView, relationships: [
                Relationship(child: 1234, parent: 1, constraints: Constraints(top: 4, bottom: -6, left: 110, right: -12), imageUrl: nil, hasShadow: false),
                Relationship(child: 4, parent: 1, constraints: Constraints(top: 12, bottom: -6, left: 12, right: -215), imageUrl: imageUrl, hasShadow: false),
                Relationship(child: 1, parent: 0, constraints: Constraints(top: 100, bottom: -690, left: 30, right: -30), imageUrl: nil, hasShadow: true)
            ])

            let data = try PropertyListEncoder().encode(remoteView)
            DataService.instance.setRemoteData(data)

        } catch {
            print(error)
        }
    }
}
