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
@property (assign, nonatomic)CLLocationCoordinate2D locationCoordinate;

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

- (IBAction)getCoordinatesWithLongPressOnMap:(UILongPressGestureRecognizer*)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchLocation = [sender locationInView:self.mapView];
    self.locationCoordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
    MKPointAnnotation *annotation             = [[MKPointAnnotation alloc] init];
    annotation.coordinate                     = self.locationCoordinate;
    [self.mapView addAnnotation:annotation];
    [self.dataController.placeManager addPlace:@{@"pinTitle": @"anun",
                                                 @"latitude": @(self.locationCoordinate.latitude),
                                                 @"longitude": @(self.locationCoordinate.longitude),}];
}

//------------------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------------------



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
