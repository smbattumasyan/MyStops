//
//  PlaceManager.h
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "CoreDataManager.h"

@interface PlaceManager : NSObject

#pragma Mark - Propertyes
@property (nonnull, strong, nonatomic) CoreDataManager            *coreDataManager;
@property (nonnull, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

#pragma Mark - Class Methods
- (void)addPlace:(nullable NSDictionary *)place;
- (void)deletePlace:(nullable Place *)place;
- (nullable Place *)fetchSelectedPlace:(nullable NSIndexPath *)indexPath;

@end
