//
//  ViewController.h
//  CelisticDataAssignment
//
//  Created by CS's on 14/07/19.
//  Copyright © 2019 Celestic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate,NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *gmsMapView;
@property (strong, nonatomic) IBOutlet UIButton *startButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *stopButtonOutlet;
@property (strong,nonatomic) NSMutableArray * coordinatesArray;
- (IBAction)startStoringTheLoation:(UIButton *)sender;
- (IBAction)stopSharingLocation:(UIButton *)sender;
- (IBAction)plotRouteFromGPXFile:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *plotFromGPXFileOutlet;

@end

