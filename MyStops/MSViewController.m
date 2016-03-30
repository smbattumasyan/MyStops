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
#import <CoreLocation/CoreLocation.h>

@interface MSViewController () <UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic  ) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLLocationManager   *manager;
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

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

//    [self.msDataController.placeManager addPlace:@{@"pinTitle": @"hi",
//                                                   @"latitude": @37.337556,
//                                                   @"longitude": @-122.037217}];
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
#pragma mark - Location Manager
//------------------------------------------------------------------------------------------

- (void)setupLocationManager
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager requestAlwaysAuthorization];
    [self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //annotation=37.337556, -122.037217
    NSLog(@"%@",locations);
    CLLocation *newLocation = [locations lastObject];
    [self getLocationCoordinate:newLocation];
    [self.manager stopUpdatingLocation];
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------
-(void)setupDirectionWithPlace:(Place *)place
{
    [self setupLocationManager];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%f,%f",[place.latitude floatValue], [place.longitude floatValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)getLocationCoordinate:(CLLocation *)location
{
    self.locationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
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
