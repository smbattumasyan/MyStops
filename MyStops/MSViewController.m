//
//  MSViewController.m
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "MSViewController.h"
#import "MSMapViewController.h"
#import "MSMapDataController.h"

@interface MSViewController () <UITableViewDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic  ) IBOutlet UITableView *tableView;

@end

@implementation MSViewController

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self.msDataController initFetchResultControler];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark - View Lifecycle
//------------------------------------------------------------------------------------------

- (void)setupTableView
{
    self.msDataController                              = [MSDataController createInstance];
    self.msDataController.placeManager                 = [[PlaceManager alloc] init];
    self.msDataController.placeManager.coreDataManager = [[CoreDataManager alloc] init];

    self.tableView.dataSource       = self.msDataController;
    self.msDataController.tableView = self.tableView;
}

//------------------------------------------------------------------------------------------
#pragma mark - IBAction
//------------------------------------------------------------------------------------------

- (IBAction)addButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"MSViewController" sender:self];
}

//------------------------------------------------------------------------------------------
#pragma mark - Table View Delegate
//------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *place = [self.msDataController.placeManager.fetchedResultsController objectAtIndexPath:indexPath];
    [self setupDirectionWithPlace:place];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------

-(void)setupDirectionWithPlace:(Place *)place
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%f,%f",[place.latitude floatValue], [place.longitude floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

//------------------------------------------------------------------------------------------
#pragma mark - Navigation
//------------------------------------------------------------------------------------------

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        if ([segue.identifier isEqualToString:@"MSViewController"]) {
            MSMapViewController *msMapViewController                        = [segue destinationViewController];
            msMapViewController.dataController                              = [MSMapDataController createInstance];
            msMapViewController.dataController.placeManager                 = self.msDataController.placeManager;
            msMapViewController.dataController.placeManager.coreDataManager = self.msDataController.placeManager.coreDataManager;
            msMapViewController.dataController.selectedIndexPath            = selectedIndexPath;
    }
}

@end
