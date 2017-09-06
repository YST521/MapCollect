//
//  ZSPointAnnotation.m
//  
//
//  Created by youxin on 2017/8/15.
//
//

#import "ZSPointAnnotation.h"

@implementation ZSPointAnnotation
- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        
        self.coordinate = CLLocationCoordinate2DMake([dict[@"coordinate"][@"latitute"] doubleValue], [dict[@"coordinate"][@"longitude"] doubleValue]);
        self.title = dict[@"detail"];
        self.name = dict[@"name"];
        self.type = dict[@"type"];
    }
    return self;
}



@end
