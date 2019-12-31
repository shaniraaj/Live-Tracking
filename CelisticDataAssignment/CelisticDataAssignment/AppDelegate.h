//
//  AppDelegate.h
//  CelisticDataAssignment
//
//  Created by CS's on 14/07/19.
//  Copyright © 2019 Celestic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

