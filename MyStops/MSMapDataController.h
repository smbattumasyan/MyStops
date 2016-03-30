//
//  MSMapDataController.h
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceManager.h"

@interface MSMapDataController : NSObject

#pragma Mark - Properties
@property (strong, nonatomic) PlaceManager *placeManager;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

#pragma Mark - Class Methods
+ (instancetype)createInstance;

@end
