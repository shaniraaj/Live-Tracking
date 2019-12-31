//
//  ViewController.m
//  CelisticDataAssignment
//
//  Created by CS's on 14/07/19.
//  Copyright © 2019 Celestic. All rights reserved.
//

#import "ViewController.h"
#import "GPSLocationGPXFileParser.h"

@interface ViewController ()
{
    CLLocationManager * locationManager;
    GMSCameraPosition *camera;
    
    NSMutableArray * userVisitedLocationArray;
}
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setBackgroundColor:[UIColor lightTextColor]];
    
    //The buttons are added from the main.storyboard file. And the outlets are created.
    
    [self.startButtonOutlet setEnabled:YES];
    [self.stopButtonOutlet setEnabled:NO];
    
    self.startButtonOutlet.layer.cornerRadius = 10;
    self.startButtonOutlet.layer.borderWidth = 3.0;
    self.stopButtonOutlet.layer.cornerRadius = 10;
    self.stopButtonOutlet.layer.borderWidth = 3.0;
    self.plotFromGPXFileOutlet.layer.cornerRadius = 10;
    self.plotFromGPXFileOutlet.layer.borderWidth = 3.0;
    
    
    self.plotFromGPXFileOutlet.layer.borderColor= self.startButtonOutlet.layer.borderColor = self.stopButtonOutlet.layer.borderColor = [UIColor grayColor].CGColor;
    self.plotFromGPXFileOutlet.backgroundColor = self.startButtonOutlet.backgroundColor = self.stopButtonOutlet.backgroundColor = [UIColor lightTextColor];
    
    userVisitedLocationArray = [NSMutableArray new];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    //Check for user permission to grant access to location services 
    
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusNotDetermined:
       case  kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
             [locationManager requestAlwaysAuthorization];
            break;
            
       case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self loadMapsWithCurrentLocationDetails];
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status==kCLAuthorizationStatusAuthorizedAlways || status==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self loadMapsWithCurrentLocationDetails];
    }
    else
    {
        UIAlertController * warningAlertController = [UIAlertController alertControllerWithTitle:@"Location Disabled" message:@"Please allow us to access your location for serving the routes properly.Navigate to settings and allow the location access for us" preferredStyle:UIAlertControllerStyleAlert];
        
        [warningAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (![userVisitedLocationArray containsObject:[locations lastObject]])
    {
        [userVisitedLocationArray addObject:[locations lastObject]];
        [self drawUserVisitedPathOnMap:userVisitedLocationArray];
    }
    
}

-(void)drawUserVisitedPathOnMap:(NSArray*)locationArrayToDraw
{
    dispatch_async(dispatch_get_main_queue(), ^{
     
        GMSMutablePath *path = [GMSMutablePath path];
  
        for (CLLocation * locationToPlot in locationArrayToDraw)
        {
            [path addCoordinate:CLLocationCoordinate2DMake(locationToPlot.coordinate.latitude,locationToPlot.coordinate.longitude)];
            
        }
        GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
        rectangle.strokeWidth = 3.0;
        rectangle.map = self.gmsMapView;
        
        GMSCoordinateBounds * bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
  
        GMSCameraUpdate * cameraUpdate = [GMSCameraUpdate fitBounds:bounds withPadding:5.0];

        [self.gmsMapView moveCamera:cameraUpdate];
    });
}


#pragma mark - GMSMAPView Delegate method

-(BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    camera = [GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude
                                               longitude:mapView.myLocation.coordinate.longitude
                                                    zoom:15];
    
    [self.gmsMapView animateToCameraPosition:camera];
    return YES;
}

- (IBAction)startStoringTheLoation:(UIButton *)sender {
    
    [self.startButtonOutlet setEnabled:NO];
    [self.stopButtonOutlet setEnabled:YES];
    [locationManager startUpdatingLocation];
    [self.coordinatesArray removeAllObjects];
    
}

- (IBAction)stopSharingLocation:(UIButton *)sender {
    
    [self.startButtonOutlet setEnabled:YES];
    [self.stopButtonOutlet setEnabled:NO];
    [locationManager stopUpdatingLocation];
}

- (IBAction)plotRouteFromGPXFile:(UIButton *)sender {
    //The GPX file will be parsed for lat lon fetching
    
    GPSLocationGPXFileParser * parser = [[GPSLocationGPXFileParser alloc] init];
    [parser parserXMLAndGenerateLocationData:self];
    
}

#pragma mark - Showing the defaults on maps

-(void)loadMapsWithCurrentLocationDetails
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->camera = [GMSCameraPosition cameraWithLatitude:18.573834
                                                   longitude:73.77684
                                                        zoom:15];
        
        self.gmsMapView.camera = self->camera;
        self.gmsMapView.settings.myLocationButton = YES;
        [[self.gmsMapView settings] setAllGesturesEnabled:YES];
        self.gmsMapView.delegate = self;
        [self.gmsMapView setPadding:UIEdgeInsetsMake(-10, -5, -60, -5)];
        [self.gmsMapView setMyLocationEnabled:YES];
    });
}



#pragma mark - Parser objects delegate methods with locations are fetched from gpx file

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"trkseg"])
    {
        self.coordinatesArray = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"trkpt"])
    {
        CLLocation * location = [[CLLocation alloc] initWithLatitude:[[attributeDict valueForKey:@"lat"] doubleValue] longitude:[[attributeDict valueForKey:@"lon"] doubleValue]];
        
        [self.coordinatesArray addObject:location];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self drawUserVisitedPathOnMap:self.coordinatesArray];
}


@end
