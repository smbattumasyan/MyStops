//
//  MSDataController.h
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceManager.h"

@interface MSDataController : NSObject<NSFetchedResultsControllerDelegate , UITableViewDataSource>

#pragma Mark - properties
@property (strong, nonatomic) PlaceManager *placeManager;
@property (strong, nonatomic) UITableView *tableView;

#pragma Mark - Class Methods
+ (instancetype)createInstance;
- (void)initFetchResultControler;

@end
