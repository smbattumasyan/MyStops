//
//  PlaceManager.m
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "PlaceManager.h"

@implementation PlaceManager

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

- (void)addPlace:(NSDictionary *)place
{
    Place *aPlace    = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:self.coreDataManager.managedObjectContext];
    aPlace.pinTitle  = [place valueForKey:@"pinTitle"];
    aPlace.latitude  = [place valueForKey:@"latitude"];
    aPlace.longitude = [place valueForKey:@"longitude"];
    [self.coreDataManager saveContext];
}

- (void)deletePlace:(Place *)place
{
    [self.coreDataManager.managedObjectContext deleteObject:place];
    [self.coreDataManager saveContext];
}

- (Place *)fetchSelectedPlace:(NSIndexPath *)indexPath
{
    return [[self fetchedResultsController] objectAtIndexPath:indexPath];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request          = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pinTitle" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    _fetchedResultsController        = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:self.coreDataManager.managedObjectContext
                                                                      sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Error Description: %@",[error userInfo]);
    }
    
    return _fetchedResultsController;
}


@end
