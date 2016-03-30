//
//  MSMapViewController.m
//  MyStops
//
//  Created by Smbat Tumasyan on 3/30/16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MSMapViewController.h"

@interface MSMapViewController ()

//------------------------------------------------------------------------------------------
#pragma mark - IBOutlets
//------------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//------------------------------------------------------------------------------------------
#pragma mark - Propertyes
//------------------------------------------------------------------------------------------
@property (strong, nonatomic)NSMutableDictionary *aPlace;

@end

@implementation MSMapViewController

//------------------------------------------------------------------------------------------
#pragma mark - Life Cyrcle
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.dataController.selectedIndexPath) {
        Place *place = [self.dataController.placeManager fetchSelectedPlace:self.dataController.selectedIndexPath];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([place.latitude floatValue], [place.longitude floatValue]);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        [self.mapView addAnnotation:annotation];

        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([place.latitude floatValue], [place.longitude floatValue]);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.05, 0.05));
        [self.mapView setRegion:region];
    }

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
    [self addPinOnMap];
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
    UIAlertController *newPinAlert = [UIAlertController alertControllerWithTitle:@"New Pin" message:@"Do you to add new Pin" preferredStyle:UIAlertControllerStyleAlert];
    [newPinAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {

        textField.placeholder  = @"Pin Name";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];

    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *textField = newPinAlert.textFields[0];
        [self.aPlace addEntriesFromDictionary:@{@"pinTitle":[NSString stringWithFormat:@"%@",textField.text]}];
        [self savePin];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];

    [newPinAlert addAction:cancel];
    [newPinAlert addAction:save];
    [self presentViewController:newPinAlert animated:YES completion:nil];
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
