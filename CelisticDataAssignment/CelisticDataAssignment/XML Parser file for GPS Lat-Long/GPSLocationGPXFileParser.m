//
//  GPSLocationGPXFileParser.m
//  CelisticDataAssignment
//
//  Created by CS's on 15/07/19.
//  Copyright © 2019 Celestic. All rights reserved.
//

#import "GPSLocationGPXFileParser.h"


@implementation GPSLocationGPXFileParser
-(void)parserXMLAndGenerateLocationData:(ViewController*)viewController
{
    NSURL * urlForGPXFile = [[NSBundle mainBundle] URLForResource:@"mapstogpx20190715_053030" withExtension:@"gpx"];
    
    NSXMLParser * parseGPXFile = [[NSXMLParser alloc] initWithContentsOfURL:urlForGPXFile];
    parseGPXFile.delegate = viewController;
    [parseGPXFile parse];
}


@end
