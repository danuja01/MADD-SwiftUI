//
//  SampleData.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-11.
//
import CoreLocation

var sampleThreads: [Thread] = [
    Thread(
        title: "Beautiful Sunset",
        caption: "Caught a stunning sunset at the beach last weekend!",
        imageUrl: "https://t3.ftcdn.net/jpg/05/28/96/86/360_F_528968647_75C1y4AO39bfmb4BeZJaC5HU9Mx9WsQr.jpg",
        location: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868),
        userImage: "https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717977600&semt=ais_user",
        userName: "naturelover",
        createdBy: "user123"
    ),
    Thread(
        title: "Snowy Mountains",
        caption: "Here's a breathtaking view of the snowy mountains I visited this winter. Here's a breathtaking view of the snowy mountains I visited this winter. Here's a breathtaking view of the snowy mountains I visited this winter. Here's a breathtaking view of the snowy mountains I visited this winter. Here's a breathtaking view of the snowy mountains I visited this winter.",
        imageUrl: "https://t3.ftcdn.net/jpg/05/28/96/86/360_F_528968647_75C1y4AO39bfmb4BeZJaC5HU9Mx9WsQr.jpg",
        location: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),
        userImage: "https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717977600&semt=ais_user",
        userName: "adventureseeker",
        createdBy: "user456"
    )
]


var sampleComments: [Comment] = [
    Comment(
        text: "This is an incredible photo! Thanks for sharing.",
        createdBy: "user123",
        userName: "natureenthusiast",
        userImage: "https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717977600&semt=ais_user"
    ),
    Comment(
        text: "Absolutely stunning view, makes me want to visit!Absolutely stunning view, makes me want to visit!Absolutely stunning view, makes me want to visit!Absolutely stunning view, makes me want to visit!Absolutely stunning view, makes me want to visit!Absolutely stunning view, makes me want to visit!",
        createdBy: "user456",
        userName: "wanderlust",
        userImage: "https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717977600&semt=ais_user"
    )
]
