//
//  GPSLocationGPXFileParser.h
//  CelisticDataAssignment
//
//  Created by CS's on 15/07/19.
//  Copyright © 2019 Celestic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GPSLocationGPXFileParser : NSObject

-(void)parserXMLAndGenerateLocationData:(ViewController*)viewController;
@end

NS_ASSUME_NONNULL_END
