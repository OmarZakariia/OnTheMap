//
//  ListTableTableViewController.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 07/10/2021.
//

import UIKit

class ListTableTableViewController: UITableViewController {
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var studentTableView: UITableView!
    
    var studentsInfo = [StudentInfo]()
    var activityViewController : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityViewController = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(activityViewController)
        activityViewController.bringSubviewToFront(self.view)
        activityViewController.center = self.view.center
        showHideActivityIndicator(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getListOfStudents()
    }
    
    // MARK: -IBFunctions
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        showHideActivityIndicator(true)
        ClientUdacity.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.showHideActivityIndicator(false)
            }
        }
    }
    
    @IBAction func refreshListButtonTapped(_ sender: UIBarButtonItem) {
        getListOfStudents()
    }
    
    
    // MARK: - Functions
    func showHideActivityIndicator(_ show: Bool){
        if show{
        activityViewController.startAnimating()
        activityViewController.isHidden = false
        } else {
            activityViewController.stopAnimating()
            activityViewController.isHidden = true
        }
    }
    
    func getListOfStudents(){
        showHideActivityIndicator(true)
        ClientUdacity.getStudentLocation() { students, error in
            self.studentsInfo = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showHideActivityIndicator(false)
                
            }
            
        }
    }
    // MARK: - TableView Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = studentsInfo[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentsInfo[indexPath.row]
        openSafariLink(student.mediaURL ?? "")
    }
}
