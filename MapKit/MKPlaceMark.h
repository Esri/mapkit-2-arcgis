//
//  MKPlaceMark.h
//  CurrentAddress
//
//  Created by Krishna on 12/18/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLPlacemark.h>
#import "MapKit.h"

MK_CLASS_AVAILABLE(NA, 3_0)
@interface MKPlacemark : CLPlacemark <MKAnnotation> {
    
}

// An address dictionary is a dictionary in the same form as returned by
// ABRecordCopyValue(person, kABPersonAddressProperty).
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
       addressDictionary:(NSDictionary *)addressDictionary;

// To create an MKPlacemark from a CLPlacemark, call [MKPlacemark initWithPlacemark:] passing the CLPlacemark instance that is returned by CLGeocoder.
// See CLGeocoder.h and CLPlacemark.h in CoreLocation for more information.

@property (nonatomic, readonly) NSString *countryCode;

@end
