//
//  TableViewController.swift
//  Note_It
//
//  Created by Dominic Egginton on 18/09/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class ListController: UITableViewController, UpdateDelagate {

    @IBOutlet var notesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func update(with note: Note, at index: Int) {
        print("delagate method called with note title \(note.title) at index \(index)")
        try? Notes.sharedInstance.update(note: note, at: index)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Notes.sharedInstance.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)

        // Configure the cell...
        
        do {
            cell.textLabel?.text = try Notes.sharedInstance.getNote(atIndex: indexPath.row).title
        } catch {
            print("Error loading notes")
        }

        return cell
    }
    
    @IBAction func newNote() {
        
        do {
            try Notes.sharedInstance.add(note: Note(title: "New Note", text: ""))
            self.notesTableView.reloadData()
            let indexPath = IndexPath(row: Notes.sharedInstance.count - 1, section: 0)
            self.notesTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            performSegue(withIdentifier: "showNote", sender: nil)
            
        } catch {
            print("error adding new note")
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showNote" {
            print("segue with \(segue.identifier!) indentifier triggered")
            if let indexPath = self.notesTableView.indexPathForSelectedRow {
                print("found row \(indexPath.row)")
                if let navigationController = segue.destination as? UINavigationController {
                    if let noteController = navigationController.topViewController as? NoteController {
                        print("Note controller found")
                        noteController.noteID = indexPath.row
                        noteController.delagate = self
                    }
                }
            }
        }
    }
    

}
