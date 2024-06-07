//
//  Thread.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//
import SwiftUI

struct Thread: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var color:String
    var image: Image
}

var sampleThreads = [
    Thread(
        title: "Mountain Adventure",
        caption: "Exploring the heights of the Rockies.",
        color: "Blue",
        image: Image("Sigiriya")
    ),
    Thread(
        title: "City Life",
        caption: "Discovering the hustle and bustle of urban centers.",
        color: "Gray",
        image: Image("cityImage")
    ),
    Thread(
        title: "Desert Exploration",
        caption: "The beauty and isolation of the desert.",
        color: "Orange",
        image: Image("desertImage")
    ),
    Thread(
        title: "Ocean Views",
        caption: "Serenity and vastness of the open water.",
        color: "Teal",
        image: Image("oceanImage")
    )
]
