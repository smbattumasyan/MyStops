//
//  MSDataController.m
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "MSDataController.h"
#import "MSViewCell.h"

@implementation MSDataController

//------------------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------------------

+ (instancetype)createInstance
{
    MSDataController *dataController = [[MSDataController alloc] init];
    return dataController;
}

//------------------------------------------------------------------------------------------
#pragma mark - Table View Data Source
//------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.placeManager.fetchedResultsController fetchedObjects] count];
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"placeCellIdentifier";
    MSViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MSViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier];
    }
    Place *place = [self.placeManager.fetchedResultsController objectAtIndexPath:indexPath];
    cell.place   = place;

    return cell;
}

- (void)initFetchResultControler
{
    self.placeManager.fetchedResultsController.delegate = self;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.placeManager deletePlace:[self.placeManager.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

//-------------------------------------------------------------------------------------------
#pragma mark - NSFetchedResultsControllerDelegate
//-------------------------------------------------------------------------------------------

- (void)controllerWillChangeContent: (NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"type = %lu", (unsigned long)type);

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths: @[newIndexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths: @[newIndexPath]
                                  withRowAnimation: UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
