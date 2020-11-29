//
//  ViewController.swift
//  CommitsApp
//
//  Created by Никита Казанцев on 21.11.2020.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var container: NSPersistentContainer!
    var commits = [Commit]()
    var commitPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
        
        // Do any additional setup after loading the view.
        
        //To set up the basic Core Data system, we need to write code that will do the following:
        //        1. Load our data model we just created from the application bundle and create a
        //        NSManagedObjectModel object from it.
        //        2. Create an NSPersistentStoreCoordinator object, which is responsible for reading
        //        from and writing to disk.
        //        3. Set up an URL pointing to the database on disk where our actual saved objects live. This will be an SQLite database named CommitsApp.sqlite.
        //        4. Load that database into the NSPersistentStoreCoordinator so it knows where we want it to save. If it doesn't exist, it will be created automatically
        //        5. Create an NSManagedObjectContext and point it at the persistent store coordinator.
        //        Beautifully, brilliantly, all five of those steps are exactly what NSPersistentContainer does for us. So what used to be 15 to 20 lines of code is now summed up in just six
        
        
        //creates the persistent container, and must be given the name of the Core Data model file we created earlier: “CommitsApp”
        container = NSPersistentContainer(name: "CommitsApp")
        
        //        The next line calls the loadPersistentStores() method, which loads the saved database if it exists, or creates it otherwise. If any errors come back here you’ll know something has gone fatally wrong, but if it succeeds then you can be guaranteed the data has loaded and you’re ready to continue.
        container.loadPersistentStores { storeDescription, error in
            //This instructs Core Data to allow updates to objects: if an object exists in its data store with message A, and an object with the same unique constraint ("sha" attribute) exists in memory with message B, the in-memory version "trumps" (overwrites) the data store version.
            self.container.viewContext.mergePolicy =
                NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        //        The Codegen value is short for “code generation” – when you pressed Cmd+B to build your project, Xcode converted the Commit Core Data entity into a Commit Swift class. You can’t see it in the project – it’s dynamically generated when the Swift code is being built – but it’s there for you to use, as you just saw. You get access to its attributes as properties that you can read and write, and any changes you make will get written back to the database when you call our saveContext() method.
        //        let commit = Commit()
        //        commit.message = "Woo"
        //        commit.url = "http://www.example.com"
        //        commit.date = Date()
        
        
        //        First, fetching the JSON. This needs to be a background operation because network requests are slow and we don't want the user interface to freeze up when data is loading This operation needs to go to the GitHub URL, https://api.github.com/repos/apple/swift/commits?per_page=100 and convert the result into a SwiftyJSON object ready for conversion.
        //        To push all this into the background, we're going to use performSelector(inBackground:)
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
    }
    
    
    //    Once you’ve finished your changes and want to write them permanently – i.e., save them to disk – you need to call the save() method on the viewContext property. However, this should only be done if there are any changes since the last save – there’s no point doing unnecessary work. So, before calling save() you should read the hasChanges property. We’re going to wrap this all up in a single method called saveContext()
    //
    //We'll be calling that whenever we've made changes that should be saved to disk.
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        } }
    
    @objc func fetchCommits() {
        if let data = try? Data(contentsOf: URL(string:"https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            let jsonCommits = try! JSON(data: data)
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    
                    //creates a Commit object inside the managed object context given to us by the NSPersistentContainer we created. This means its data will get saved back to the SQLite database when we call saveContext().
                    let commit = Commit(context: self.container.viewContext)
                    
                    //Once we have a new Commit object, we pass it onto the configure(commit:) method, along with the JSON data for the matching commit. That Commit object is our NSManagedObject subclass, so it has all sorts of magic behind the scenes, but to our Swift code is just a normal object with properties we can read and write. This would make the configure(commit:) method straightforward if it were not for dates.
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                self.saveContext()
                self.loadSavedData()
            }
            
        } }
    
    //Before we show you the new configure(commit:) method, there's one more thing you need to know: getting an Date out of a string might fail, for example if the string isn’t in ISO-8601 format. In this case, we'll get nil back, which isn't much good for our app, so we’re going to use the nil coalescing operator to use a new Date instance if the date failed to parse.
    func configure(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
        
        var commitAuthor: Author!
        // see if this author exists already
        let authorRequest = Author.createFetchRequest()
        authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["committer"]["name"].stringValue)
        if let authors = try? container.viewContext.fetch(authorRequest) {
            if authors.count > 0 {
                // we have this author already
                commitAuthor = authors[0]
            }
        }
        
        if commitAuthor == nil {
            // we didn't find a saved author - create a new one!
            
            let author = Author(context: container.viewContext)
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            commitAuthor = author
        }
        // use the author, either saved or new
        commit.author = commitAuthor
    }
    
    
    
    //We need to write one new method in order to make our entire app spring into life. But before we jump into the code, you need to learn about one of the most important classes in Core Data: NSFetchRequest. This is the class that performs a query on your data, and returns a list of objects that match.
    //    We're going to use NSFetchRequest in a really basic form for now, then add more functionality later. In this first version, we're going to ask it to give us an array of all Commit objects that we have created, sorted by date descending so that the newest commits come first.
    //    The way fetch requests work is very simple: you create one from the NSManagedObject subclass you’re using for your entity, then pass it to managed object context’s fetch() method. If the fetch request worked then you'll get back an array of objects matching the query; if not, an exception will be thrown that you need to catch.
    //    The sorting is done through a special data type called NSSortDescriptor, which is a trivial wrapper around the name of what you want to sort (in our case "date"), then a boolean setting whether the sort should be ascending (oldest first for dates) or descending (newest first). You pass an array of these, so you can say "sort by date descending, then by message ascending," for example.
    
    //So, that creates the NSFetchRequest, gives it a sort descriptor to arrange the newest commits first, then uses the fetch() method to fetch the actual objects. That method returns an array of all Commit objects that exist in the data store. Once that's done, it's just a matter of calling reloadData() on the table to have the data appear.
    
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter commits...", message: nil,
                                   preferredStyle: .actionSheet)
        
        //Like we said, "I fixed a bug in Swift" isn't the kind of commit message you'll see in your data, so == isn't really a helpful operator for our app. So let's write a real predicate that will be useful
        //The CONTAINS[c] part is an operator, just like ==, except it's much more useful for our app. The CONTAINS part will ensure this predicate matches only objects that contain a string somewhere in their message
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default)
        { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
            self.loadSavedData()
        })
        
        
        //Another useful string operator is BEGINSWITH, which works just like CONTAINS except the matching text must be at the start of a string. To make this second example more exciting, we're also going to introduce the NOT keyword, which flips the match around: this action below will match only objects that don't begin with 'Merge pull request'. Put this in place of the // 2 comment:
        ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default)
        { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        })
        
        
        //For a third and final predicate, let's try filtering on the "date" attribute. This is the Date data type, and Core Data is smart enough to let us compare that date to any other date inside a predicate. In this example, which should go in place of the // 3 comment, we're going to request only commits that took place 43,200 seconds ago, which is equivalent to half a day:
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default)
        { [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as
                                                NSDate)
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show only Durian commits",
        style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
            self.loadSavedData()
        })

        //For the final comment, // 4, we're just going to set commitPredicate to be nil so that all
        //commits are shown again:
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default)
        { [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func loadSavedData() {
        let request = Commit.createFetchRequest()
        
        request.predicate = commitPredicate
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        do {
            commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
                                section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
                                IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for:
                                                    indexPath)
        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = "By \(commit.author!.name) on \(commit.date.description)"
        return cell }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
    IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier:
    "Detail") as? DetailViewController {
            vc.detailItem = commits[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
     }
}

