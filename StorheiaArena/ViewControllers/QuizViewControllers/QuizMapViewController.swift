//
//  QuizMapViewController.swift
//  StorheiaArena
//
//  Created by Kostas Lei on 21/05/2021.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class QuizMapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var questionsLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    
    var pins = [MKPointAnnotation]()
    var pinCoordinates = [CLLocationCoordinate2D]()
    let locationManager = CLLocationManager()
    var questions = [Question]()
    var questionsAsked = [Question]()
    
    var navigationBarConfig: NavigationBarConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfig()
        mapViewSetup()
        
        checkMonitoringAvailable()
        addPinsToMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        labelsConfig()
    }
    
    // Stop tracking regions
    deinit {
        for region in locationManager.monitoredRegions{
            print(region)
            locationManager.stopMonitoring(for: region)
        }
        mapView.removeAnnotations(mapView.annotations)
        questions.removeAll()
    }
    
    // MARK: CONFRIGURATION FUNCTIONS
    // Configure label text
    func labelsConfig() {
        self.pointsLabel.text = "Score: \(DataModel.userData.Score)"
        self.usernameLabel.text = "Username:" + DataModel.userData.firstName + " " + DataModel.userData.lastName
        self.questionsLabel.text = "Questions: \(DataModel.userData.questionsAnswered)"
    }
    
    // Configure Navbar title and back button
    func navBarConfig() {
        navigationBarConfig = NavigationBarConfiguration(navController: navigationController!, vc: self)
        navigationBarConfig.navBarWithBackButton()
    }
    
    // Make sure region monitoring is supported.
    func checkMonitoringAvailable() {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: "Monitoring is not supported on this device!", buttonTitle: "OK", viewController: self)
            
            return
        }
    }
    
    // Configure map
    func mapViewSetup() {
        locationManager.delegate = self
        
        // Ask for authentication
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Show compass on map
        mapView.showsCompass = true
        
        // Center map on pins location
        let center = CLLocationCoordinate2D(latitude: (68.504775), longitude: (14.896827))
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 5000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    // Start monitoring regions
    func startMonitoringRegion(regionID: Int, center: CLLocationCoordinate2D) {
        
        // Register the region.
        let region = CLCircularRegion(center: center, radius: 100, identifier: "RegionID\(regionID)")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        // Start monitoring region
        locationManager.startMonitoring(for: region)
    }
    
    // Add pins on map and start monitoring them
    func addPinsToMap() {
        
        // Coordinates to be tracked
        var locations = [CLLocationCoordinate2D]()
        locations.append(CLLocationCoordinate2D(latitude: 68.503135, longitude: 14.873470))
        locations.append(CLLocationCoordinate2D(latitude: 68.502560, longitude: 14.833803))
        locations.append(CLLocationCoordinate2D(latitude: 68.501789, longitude: 14.807642))
        locations.append(CLLocationCoordinate2D(latitude: 68.504775, longitude: 14.896827))
        locations.append(CLLocationCoordinate2D(latitude: 68.507159, longitude: 14.909393))
        
        locations.append(CLLocationCoordinate2D(latitude: 68.509752, longitude: 14.920196))
        locations.append(CLLocationCoordinate2D(latitude: 68.510786, longitude: 14.923945))
        locations.append(CLLocationCoordinate2D(latitude: 68.513295, longitude: 14.928838))
        locations.append(CLLocationCoordinate2D(latitude: 68.518317, longitude: 14.939308))
        locations.append(CLLocationCoordinate2D(latitude: 68.523560, longitude: 14.954069))
        
        var i = 0
        for location in locations{
            
            // Create an annotation, set coordinates and add to map
            let myPin:MKPointAnnotation = MKPointAnnotation()
            myPin.coordinate = location
            mapView.addAnnotation(myPin)
            
            // Adds circle around pin
            let circle = MKCircle(center: location , radius: 100)
            mapView.addOverlay(circle)
            
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            // If app has access on users location, start monitoring the locations
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                startMonitoringRegion(regionID: i, center: center)
            }
            i += 1
        }
    }
    
    // MARK: QUIZ LOGIC FUNCTIONS
    // Get a question randomly from the questions array
    func quizRandomQuestion() -> Question {
        
        // Questions that haven't been answered
        let filteredQuestions = questions.filter { question in
            !DataModel.questionsAsked.contains(question)
        }
        
        // Get random question
        if !filteredQuestions.isEmpty{
            let question = filteredQuestions.randomElement()
            DataModel.questionsAsked.append(question!)
            return question!
        }
        
        // If all questions have answered, start from the begin
        else {
            DataModel.questionsAsked.removeAll()
            return questions.randomElement()!
        }
    }
    
    // Transfer to quizViewController
    func transferToQuiz() {
        let question = quizRandomQuestion()
        let vc = storyboard?.instantiateViewController(identifier: "QuizVC") as! QuizViewController
        vc.question = question
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: CLLocationManagerDelegate
extension QuizMapViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    // If authorization success, show user location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        mapView.showsUserLocation = (status == .authorizedWhenInUse || status == .authorizedAlways)
        
        // If can access device location, inform user and ask again to give access
        if status != .authorizedAlways || status != .authorizedWhenInUse {
            let message = "The quiz is using the devices location. Please give access to your devices location."
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        AlertNotifications.oneButtonAlertNotification(alertTitle: "Warning", alertMessage: "Location monitoring failed!", buttonTitle: "OK", viewController: self)
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    // When user is entering the tracking area, transfer to quizViewController
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            let identifier = region.identifier
            triggerTaskAssociatedWithRegionIdentifier(regionID: identifier)
        }
    }
    
    func triggerTaskAssociatedWithRegionIdentifier(regionID: String){
        transferToQuiz()
    }
}
