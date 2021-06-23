# Fetch Rewards - Seat Geek Exercise

<p align="center">
  <img src="https://user-images.githubusercontent.com/6796434/123179374-e2a60200-d44e-11eb-8409-11a0bd8a20f7.png" height="70%" width="200"/>
</p>

## Information

### What is this?
So I was tasked with created a simple iOS app as an exercise for Fetch Rewards (full exercise is described further down the README).
The requirements were simple interactions with the SeatGeek public API.
While I didn't have the time I needed to fully complete my vision for this fun exercise, I did manage to at least clone most of the nice UI components that SeatGeek offers in their iOS app.

### What can you do?

The app has 3 tabs: Browse, Search and Tracking.
#### Browse
This will be the first to appear when you launch the app. It should immediately fetch multiple events/genres/performers from the SeatGeek API and present them all in a list page, quite similar to SeatGeek's real browse tab.
You can add events/performers to your tracked list (and they will appear in the tracked tab).
You can tap events to see their details.

#### Search 
This page will allow you to free search events and see the results.
Tapping on a result will show you the details for the event.

#### Tracking
This page will show you all your tracked events.
You can untrack events here as well.
Tapping on a result will show you the details for the event.

## Notes from the developer

I really wanted to go all out with this exercise and create some cool transitions and invest a lot of time in the test cases, animations, architecture, etc, but ended up being too busy with many other job interviews.
I started supporting performer details and viewing a list of events by tapping "View all" and tapping a genre but, again, I didn't have the time :(
Of course, due to this just being an exercise and due to lack of time, I had to cut some corners (and it was painful) for the sake of time.

For whoever checks out this project - I hope you enjoy it.
If you find bugs or crashes, let's assume this is a feature :D

## Usage Instructions

### Requirements to run

- XCode 12.x.x and above.
- Device/Simulator running iOS 12 and above.
- the `api-keys.plist` file (ask the developer for the file if one was not included already with a link to this repo).

### How to run

- Clone the repository or download the zip.
- Copy the included `api-keys.plist` to the root folder of the project.
- Launch the `fetch-seat-geek.xcworkspace`
- Build and run the project on a simulator or a connected device.

## The Exercise

Create an iOS application that would consume the open-source SeatGeek API and display events in a UITableView as shown in the below screenshots. To search an event UISearchBar should be used and it should be placed on the top of the UITableView. The application needs to fetch relevant events from SeatGeek API while user is typing in the search bar.
Tapping on Event UITableViewCell should display the corresponding event in a detail screen. Tapping on the back button should take user back to the events tableview.
User should be able to favorite events from the detail screen by hitting the favorite button. Favorited events should be displayed on the events tableview as shown below.
Even when searching or closing the application, a favorited event should remain favorited. A user should be able to unfavorite the event as well.
   
<b>Requirements</b>
• Write your application for Native iOS Platform preferably with Swift (or Objective-C)
• Favorited events are persisted between app launches
• Events are searchable through SeatGeek API
• Unit tests are preferable.
• Third party libraries are allowed.
• Cocoapods, Carthage, Swift Package Manager are all allowed as long as there is a
clear instructions on how to build and run the application.
• Make sure that the application supports iOS 12 and above.
• The application must compile with Xcode 12.x.x
• Please add a README or equivalent documentation about your project.
• The screenshots are just blueprints. UI doesn’t have to follow them.

## Author

DDraiman1990, ddraiman1990@gmail.com a.k.a Nexxmark Studio.
