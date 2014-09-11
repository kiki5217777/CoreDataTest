//
//  MapRouteViewController.m
//  CoreDataTest
//
//  Created by kiki Huang on 13/12/3.
//  Copyright (c) 2013年 kiki Huang. All rights reserved.
//

#import "MapRouteViewController.h"

@interface MapRouteViewController (){
    Annotation *start,*end;
    Annotation *desPin;
    CLLocationCoordinate2D distionation_coords;
    NSString *distance,*time;
    double D_distance;
}

@end

@implementation MapRouteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"search" style:self.editButtonItem.style target:self action:@selector(searchLocation)];
    [self userLocationInit];
    
    start = [[Annotation alloc]init];
    start.title = @"起點";
    end = [[Annotation alloc]init];
    end.title = @"終點";
    start.latitude = 25.026737;
    start.longitude = 121.476932;
    end.latitude = 25.021433;
    end.longitude = 121.468467;
    [self.myMapRouteView addAnnotation:start];
    [self.myMapRouteView addAnnotation:end];
    [self updateOverlays];
    
    //encloseing annotation views on screen
    /*
    MKPointAnnotation *a = [[MKPointAnnotation alloc]init];
    a.title = @"Honolulu, HI";
    a.coordinate = CLLocationCoordinate2DMake(19.47695, -155.566406);
    
    MKPointAnnotation *b = [[MKPointAnnotation alloc]init];
    b.title = @"Sydney, Australia";
    b.coordinate = CLLocationCoordinate2DMake(-26.431228, 151.347656);
    [self.myMapRouteView showAnnotations:@[a,b] animated:NO];
    */
    
    /*
    //3D map
    self.myMapRouteView.centerCoordinate = CLLocationCoordinate2DMake(40.714623, -74.006605);
    self.myMapRouteView.camera.altitude = 200;
    self.myMapRouteView.camera.pitch = 70;
    self.myMapRouteView.showsBuildings = YES;
    */
    
    
    //MKTileOverlay
    /*
    NSString *template = @"http://mw1.google.com/mw-planetary/sky/skytiles_v1/{x}_{y}_{z}.jpg";
    MKTileOverlay *overlay = [[MKTileOverlay alloc]initWithURLTemplate:template];
    overlay.canReplaceMapContent = YES;
    [self.myMapRouteView addOverlay:overlay level:MKOverlayLevelAboveRoads];
    */
    //mapbox
    /*
    self.myMapUIView.tileSource = [[RMMapBoxSource alloc]initWithMapID:@"kk5217777.glna2am4"enablingDataOnMapView:self.myMapUIView];
    self.myMapUIView.delegate = self;
    self.myMapUIView.zoom = 2;
    [self.myMapUIView setConstraintsSouthWest:[self.myMapUIView.tileSource latitudeLongitudeBoundingBox].southWest northEast:[self.myMapUIView.tileSource latitudeLongitudeBoundingBox].northEast];
    self.title = [self.myMapUIView.tileSource shortName];
    
    __weak RMMapView *weakMap = self.myMapUIView;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        float degreeRadius = 9000.f/110000.f;
        CLLocationCoordinate2D centerCoordinate = [((RMMapBoxSource *)self.myMapUIView.tileSource) centerCoordinate];
        RMSphericalTrapezium zoomBounds = {.southWest = {
            .latitude  = centerCoordinate.latitude  - degreeRadius,
            .longitude = centerCoordinate.longitude - degreeRadius
        },
            .northEast = {
                .latitude  = centerCoordinate.latitude  + degreeRadius,
                .longitude = centerCoordinate.longitude + degreeRadius
            }
        };
        [weakMap zoomWithLatitudeLongitudeBoundsSouthWest:zoomBounds.southWest northEast:zoomBounds.northEast animated:YES];
    });*/
    
    /*
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(37.501364, -122.182817);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.906448, 0.878906);
    self.myMapRouteView.region = MKCoordinateRegionMake(centerCoordinate, span);
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
         return nil;
    }
    
    NSString *annotationIndentifier =@"PinViewAnnotation";
    pinView = [[PinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIndentifier];
    pinView.canShowCallout = NO;
    pinView.image = [UIImage imageNamed:@"location_pin.png"];
    [pinView setFrame:CGRectMake(0, 0, 25, 30)];
    pinView.annotation = annotation;
   
    return pinView;
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(-75, -90, 150, 90)];
    [customView setBackgroundColor:[UIColor colorWithRed:215.0f/255 green:235.0f/255 blue:255.0f/255 alpha:1.0f]];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images.jpg"]];
    [iconView setFrame:CGRectMake(0, 0, 30, 30)];
    [customView addSubview:iconView];
    
    UILabel *distination = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    distination.text = self.localSearchLabel.text;
    [customView addSubview:distination];
    
    UILabel *dis = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 300, 30)];
    dis.text = [NSString stringWithFormat:@"距離：%.0f 公尺",roundf(D_distance)];
    [customView addSubview:dis];
    UILabel *expectedTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 300, 30)];
    expectedTime.text =[NSString stringWithFormat:@"預估時間：%@",time];
    [customView addSubview:expectedTime];
    
    [view addSubview:customView];
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    if (![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        for(UIView *subview in [view subviews]) {
            [subview removeFromSuperview];
        }
    }
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor purpleColor];
    return renderer;
     
//    return [[MKTileOverlayRenderer alloc]initWithOverlay:overlay];
}

-(void)updateOverlays{
    CLLocationCoordinate2D points[] = {start.coordinate,end.coordinate};
    MKGeodesicPolyline *geodesic = [MKGeodesicPolyline polylineWithCoordinates:points count:2];
    [self.myMapRouteView addOverlay:geodesic];
}
-(void)userLocationInit{
    if (self.delegate.myLocation.latitude !=0 && self.delegate.myLocation.longitude!=0) {
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta = 0.009;
        theSpan.longitudeDelta = 0.009;
        
        MKCoordinateRegion theRegion;
        theRegion.span = theSpan;
        theRegion.center = self.delegate.myLocation;
        [self.myMapRouteView setRegion:theRegion];
        [self.myMapRouteView regionThatFits:theRegion];
        self.myMapRouteView.showsUserLocation = YES;
    }
}
-(void)searchLocation{
    
    if (self.localSearchLabel!=nil && self.localSearchLabel.text.length !=0) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
        request.naturalLanguageQuery = self.localSearchLabel.text;
        request.region = self.myMapRouteView.region;
        
        MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            NSMutableArray *placemarks = [NSMutableArray array];
            for (MKMapItem *item in response.mapItems) {
                [placemarks addObject:item.placemark];
            }
//            [self.myMapRouteView removeAnnotations:[self.myMapRouteView annotations]];
            [self.myMapRouteView showAnnotations:placemarks animated:NO];
            [self.myMapRouteView addAnnotation:[placemarks objectAtIndex:0]];
        }];

    }
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.localSearchLabel resignFirstResponder];
    return YES;
}

- (IBAction)searchDirection:(id)sender {
    
    
    if (self.localSearchLabel!=nil && self.localSearchLabel.text.length !=0) {
        
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        [geocoder geocodeAddressString:self.localSearchLabel.text completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"Geocode failed with error %@",error);
                return;
            }
            else if(placemarks && placemarks.count>0) {
                
                //create user location mapitem
                MKPlacemark *userlocationPlacemakr = [[ MKPlacemark alloc]initWithCoordinate:self.myMapRouteView.userLocation.coordinate addressDictionary:nil];
                MKMapItem *startItem = [[MKMapItem alloc]initWithPlacemark:userlocationPlacemakr];
                
                //clear map view
//                [self.myMapRouteView removeAnnotations:self.myMapRouteView.annotations];
                [self.myMapRouteView removeOverlays:self.myMapRouteView.overlays];
                
                //get destination coordinate infomation
                CLPlacemark *placemark = placemarks[0];
                CLLocation *location = placemark.location;
                distionation_coords = location.coordinate;
//                NSLog(@"des coord lat:%f long:%f",distionation_coords.latitude,distionation_coords.longitude);
                MKPlacemark *desPlacemakr = [[ MKPlacemark alloc]initWithCoordinate:distionation_coords addressDictionary:nil];
                MKMapItem *stopItem = [[MKMapItem alloc]initWithPlacemark:desPlacemakr];
                
                // display direction from current location to destination location
                

                //add destination annotation
                desPin = [[Annotation alloc]init];
                desPin.title = self.localSearchLabel.text;
                desPin.latitude = distionation_coords.latitude;
                desPin.longitude = distionation_coords.longitude;
                [self.myMapRouteView addAnnotation:desPin];
                
                [self findDirectionsFrom:startItem to:stopItem];
//                [self showDirection];
                placemark = nil;
                userlocationPlacemakr = nil;
                startItem =nil;
                location = nil;
                desPlacemakr = nil;
                stopItem = nil;
                
            }
        }];
    }
    
}
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    id page2 = segue.destinationViewController;
//    [page2 setValue:self forKey:@"showRouteDelegate"];
//}
//-(void)searchLocation:(int)ok{
//    NSLog(@"ok %d",ok);
//}
/*
-(void)searchLocation:(NSString *)address1 stop:(NSString *)address2{
    NSLog(@"address1 :%@ , address2 :%@",address1,address2);
    if (address1!=nil && address1.length !=0 && address2 !=nil && address2.length!=0) {
        
        MKLocalSearchRequest *request1 = [[MKLocalSearchRequest alloc]init];
        request1.naturalLanguageQuery = address1;
        request1.region = self.myMapRouteView.region;
        
        MKLocalSearch *search1 = [[MKLocalSearch alloc]initWithRequest:request1];
        [search1 startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            NSMutableArray *placemarks = [NSMutableArray array];
            
            for (MKMapItem *item in response.mapItems) {
                [placemarks addObject:item.placemark];
            }
            NSLog(@"search1 count %lu",(unsigned long)[placemarks count]);
            [self.myMapRouteView showAnnotations:placemarks  animated:YES];
            [placemarks removeAllObjects];
             placemarks = nil;
            
            MKLocalSearchRequest *request2 = [[MKLocalSearchRequest alloc]init];
            request2.naturalLanguageQuery = address2;
            request2.region = self.myMapRouteView.region;
            
            MKLocalSearch *search2 = [[MKLocalSearch alloc]initWithRequest:request2];
            [search2 startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
                NSMutableArray *placemarks = [NSMutableArray array];
                
                for (MKMapItem *item in response.mapItems) {
                    [placemarks addObject:item.placemark];
                    
                }
                NSLog(@"search2 count %lu",(unsigned long)[placemarks count]);
                [self.myMapRouteView showAnnotations:placemarks animated:YES];
                [placemarks removeAllObjects];
                placemarks = nil;
//                [self findDirectionsFrom:startItem to:stopItem];
            }];
        }];
        
        
        
    }
}*/
-(void)findDirectionsFrom:(MKMapItem*)source to:(MKMapItem *)destination{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.source = source;
    request.destination =destination;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error :%@",[error debugDescription]);
        }else{
            
            NSLog(@"route count %lu",(unsigned long)[response.routes count]);
            if ([response.routes count]>0) {
                MKRoute *route = response.routes[0];
                MKDistanceFormatter *distanceFormat = [[MKDistanceFormatter alloc]init];
                distance = [distanceFormat stringFromDistance:route.distance];
                D_distance = route.distance;
                NSInteger ti = route.expectedTravelTime;
                NSInteger seconds = ti%60;
                NSInteger minutes = (ti/60)%60;
                NSInteger hous = ti/3600;
                
                time = [NSString stringWithFormat:@"%02li:%02li:%02li",(long)hous,(long)minutes,(long)seconds];
                NSLog(@"route distance %@ time %@",distance,time);
                [self.myMapRouteView addOverlay:route.polyline];
            }
           
//            [self showDirections:response];
        }
    }];
}
-(void)showDirections:(MKDirectionsResponse*)response{
    for (MKRoute *route in response.routes) {
        [self.myMapRouteView addOverlay:route.polyline];
    }
}
-(void)showDirection{
    MKPlacemark *place = [[MKPlacemark alloc]initWithCoordinate:distionation_coords addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:place];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    [mapItem openInMapsWithLaunchOptions:options];
}
/*
#pragma mark -

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker = [[RMMarker alloc] initWithMapBoxMarkerImage:[annotation.userInfo objectForKey:@"marker-symbol"]
                                                      tintColorHex:[annotation.userInfo objectForKey:@"marker-color"]
                                                        sizeString:[annotation.userInfo objectForKey:@"marker-size"]];
    
    marker.canShowCallout = YES;
    
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    if (self.activeFilterTypes)
        marker.hidden = ! [self.activeFilterTypes containsObject:[annotation.userInfo objectForKey:@"marker-symbol"]];
    
    return marker;
}*/
/*
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    MBWPDetailViewController *detailController = [[MBWPDetailViewController alloc] initWithNibName:nil bundle:nil];
    
    detailController.detailTitle       = [annotation.userInfo objectForKey:@"title"];
    detailController.detailDescription = [annotation.userInfo objectForKey:@"description"];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark -

- (void)searchViewController:(MBWPSearchViewController *)controller didApplyFilterTypes:(NSArray *)filterTypes
{
    self.activeFilterTypes = filterTypes;
    
    for (RMAnnotation *annotation in self.mapView.annotations)
        if ( ! annotation.isUserLocationAnnotation)
            annotation.layer.hidden = ! [self.activeFilterTypes containsObject:[annotation.userInfo objectForKey:@"marker-symbol"]];
}*/
@end
