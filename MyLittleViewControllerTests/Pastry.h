//
//  Pastry.h
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PastryType) {
    PastryTypeRaspberry,
    PastryTypeLemon,
    PastryTypeChocolate,
    PastryTypeGlazed,
};

@interface Pastry : NSObject
+ (instancetype)pastryNamed:(NSString *)name calories:(NSInteger)calories type:(PastryType)type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger calories;
@property (nonatomic) PastryType pastryType;
@end

id (^ const pastryTypeBlock)(id);
NSString *(^ const pastryTypeNameBlock)(id);
