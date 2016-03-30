//
//  MSMapViewController.m
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MSMapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MSMapViewController () <CLLocationManagerDelegate>

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//------------------------------------------------------------------------------------------
#pragma mark - Propertyes
//------------------------------------------------------------------------------------------
@property (strong, nonatomic         ) NSMutableDictionary *aPlace;
@property (strong, nonatomic) CLLocationManager   *manager;
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

@end

@implementation MSMapViewController

//------------------------------------------------------------------------------------------
#pragma mark - Life Cyrcle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self setupLocationManager];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------
#pragma mark - IBAction
//------------------------------------------------------------------------------------------

- (IBAction)LongPressOnMapAction:(UILongPressGestureRecognizer*)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchLocation = [sender locationInView:self.mapView];
    [self getPinCoordinatesFromMap:touchLocation];
    [self alertNewPin];
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------

-(void)getPinCoordinatesFromMap:(CGPoint)touchLocation
{
    CLLocationCoordinate2D locationCoordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
    self.aPlace = [[NSMutableDictionary alloc] initWithDictionary:@{@"latitude": @(locationCoordinate.latitude),
                                                                   @"longitude": @(locationCoordinate.longitude),}];
}

- (void)addPinOnMap
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude   = [[self.aPlace valueForKey:@"latitude"] floatValue];
    locationCoordinate.longitude  = [[self.aPlace valueForKey:@"longitude"] floatValue];
    annotation.coordinate         = locationCoordinate;
    [self.mapView addAnnotation:annotation];
}

- (void)savePin
{

    NSLog(@"%@",self.aPlace);
    [self.dataController.placeManager addPlace:self.aPlace];
}

- (void)alertNewPin
{
    UIAlertController *newPinAlert = [UIAlertController alertControllerWithTitle:@"New Pin" message:@"Do you to add new pin here" preferredStyle:UIAlertControllerStyleAlert];
    [newPinAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {

        textField.placeholder  = @"Pin Name";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];

    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *textField = newPinAlert.textFields[0];
        [self.aPlace addEntriesFromDictionary:@{@"pinTitle":[NSString stringWithFormat:@"%@",textField.text]}];
        [self savePin];
        [self addPinOnMap];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];

    [newPinAlert addAction:cancel];
    [newPinAlert addAction:save];
    [self presentViewController:newPinAlert animated:YES completion:nil];
}

//location Manager

- (void)setupLocationManager
{
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager requestAlwaysAuthorization];
    [self.manager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //annotation=37.337556, -122.037217
    NSLog(@"%@",locations);
    CLLocation *newLocation = [locations lastObject];
    self.locationCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationCoordinate, MKCoordinateSpanMake(0.05, 0.05));
    [self.mapView setRegion:region];
    [self.manager stopUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
