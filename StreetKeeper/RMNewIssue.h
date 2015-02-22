//
//  RMNewIssue.h
//  StreetKeeper
//
//  Created by Dan Rudolf on 2/21/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface RMNewIssue : NSObject

@property NSString *title;
@property PFGeoPoint *location;
@property NSString *about;
@property NSString *status;
@property NSString *address;
@property PFFile *image;
@property NSNumber *priority;

@end
