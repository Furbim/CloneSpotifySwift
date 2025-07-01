//
//  CurtidasViewController.swift
//  SpotifyClone
//
//  Created by COTEMIG on 01/07/25.
//

import UIKit

struct MusicData {
    let title: String
    let artist: String
}

class CurtidasViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView2: UITableView!
    
    let likedSongs: [MusicData] = [
        MusicData(title: "Niggas in Paris", artist: "Jay-Z & Kanye West"),
        MusicData(title: "Blinding Lights", artist: "The Weeknd"),
        MusicData(title: "Lose Yourself", artist: "Eminem"),
        MusicData(title: "Billie Jean", artist: "Michael Jackson")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView2.dataSource = self
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedSongs.count
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? MusicTableViewCell else {
            return UITableViewCell()
        }

        let song = likedSongs[indexPath.row]
        cell.musicTitleLabel.text = song.title
        cell.artistNameLabel.text = song.artist
        
        return cell
    }
}
