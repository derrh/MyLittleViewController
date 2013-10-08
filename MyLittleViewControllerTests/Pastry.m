//
//  Pastry.m
//  MyLittleViewController
//
//  Created by derrick on 10/8/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "Pastry.h"

id (^ const pastryTypeBlock)(id) = ^(Pastry *pastry) {
    return @(pastry.pastryType);
};

NSString *(^ const pastryTypeNameBlock)(id) = ^(Pastry *pastry) {
    switch (pastry.pastryType) {
        case PastryTypeRaspberry:
            return @"Raspberry";
        case PastryTypeChocolate:
            return @"Chocolate";
        case PastryTypeLemon:
            return @"Lemon";
        case PastryTypeGlazed:
            return @"Glazed";
    }
    return @"";
};


@implementation Pastry
+ (instancetype)pastryNamed:(NSString *)name calories:(NSInteger)calories type:(PastryType)type {
    Pastry *me = [self new];
    me.name = name;
    me.calories = calories;
    me.pastryType = type;
    return me;
}

- (BOOL)isEqual:(id)object
{
    return [object isMemberOfClass:[Pastry class]] && [self.name isEqualToString:[object name]] && self.pastryType == [object pastryType] && self.calories == [object calories];
}

- (NSUInteger)hash
{
    return self.name.hash + 31 * self.calories + 11 * self.pastryType;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"pastry (%u) = %@ \"%@\"", self.pastryType, pastryTypeNameBlock(self), self.name];
}

@end