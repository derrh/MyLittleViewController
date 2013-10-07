//
//  MLVCCollectionControllerSpec.m
//  MyLittleViewController
//
//  Created by derrick on 10/2/13.
//  Copyright 2013 Instructure. All rights reserved.
//

#import "Kiwi.h"
#import "MLVCCollectionController.h"
#import <UIKit/UIKit.h>

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



SPEC_BEGIN(MLVCCollectionControllerSpec)

describe(@"MLVCCollectionController", ^{
   context(@"When created", ^{
       NSString *(^testBlock)(id object) = ^(id object) { return @"Hello, world!"; };
       NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
       MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:testBlock groupTitleBlock:testBlock sortDescriptors:sortDescriptors];
       
       it(@"has the right sortDescriptors", ^{
           [[controller.sortDescriptors should] equal:sortDescriptors];
       });
       it(@"has the right groupKeyPath", ^{
           [[controller.groupByBlock should] equal:testBlock];
       });
       it(@"has the right title block", ^{
           [[controller.groupTitleBlock should] equal:testBlock];
       });
       it(@"has a non-nil array of groups", ^{
           [[controller.groups shouldNot] beNil];
       });
       it (@"has an empty array of groups", ^{
           [[theValue(controller.groups.count) should] equal:theValue(0)];
       });
    });
    
    context(@"When created with nil block params", ^{
        NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"cats" ascending:YES]];
        MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:sortDescriptors];
        
        it(@"has a non-nil groupByBlock", ^{
            [[controller.groupByBlock shouldNot] beNil];
        });
        it(@"has a non-nil titleBlock", ^{
            [[controller.groupTitleBlock shouldNot] beNil];
        });
    });
    
    context(@"When created with no sort descriptors", ^{
        it(@"throws an exception", ^{
            [[theBlock(^{
                [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:nil];
            }) should] raise];
            [[theBlock(^{
                [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[]];
            }) should] raise];
        });
    });
    
    
    context(@"When inserting an object", ^{
        MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:nil groupTitleBlock:nil sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
        [controller insertObjects:@[@"aaa"]];
        
        it(@"has only one object", ^{
            [[theValue([controller.groups count]) should] equal:theValue(1)];
            [[theValue([[controller[0] objects] count]) should] equal:theValue(1)];
        });
        it(@"has only one group", ^{
            [[theValue([controller.groups count]) should] equal:theValue(1)];
            [[theValue(controller[0]) shouldNot] beNil];
        });
        it(@"should have @\"aaa\" at [0][0], indexPath 0,0 and arrangedObjects[0]", ^{
            [[controller[0][0] should] equal:@"aaa"];
            [[[controller objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should] equal:@"aaa"];
        });
    });
    
    
    context(@"When a controller groups pastries by type", ^{
        MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:pastryTypeBlock groupTitleBlock:pastryTypeNameBlock sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"pastryType" ascending:YES]]];
        
        [controller insertObjects:@[
                                    [Pastry pastryNamed:@"Glazed Donut" calories:280 type:PastryTypeGlazed],
                                    [Pastry pastryNamed:@"Lemon Bar" calories:260 type:PastryTypeLemon],
                                    [Pastry pastryNamed:@"Chocolate Cake Donut" calories:300 type:PastryTypeChocolate],
                                    ]];
        
        it(@"should sort lemon pastries first", ^{
            [[[controller[0] title] should] equal:@"Lemon"];
            [[[controller[0] id] should] equal:theValue(PastryTypeLemon)];
            [[theValue([controller[0][0] pastryType]) should] equal:theValue(PastryTypeLemon)];
        });
        it(@"should sort chocolate next", ^{
            [[[controller[1] title] should] equal:@"Chocolate"];
            [[[controller[1] id] should] equal:theValue(PastryTypeChocolate)];
            [[theValue([controller[1][0] pastryType]) should] equal:theValue(PastryTypeChocolate)];
        });
        it(@"should sort glazed last", ^{
            [[[controller[2] title] should] equal:@"Glazed"];
            [[[controller[2] id] should] equal:theValue(PastryTypeGlazed)];
            [[theValue([controller[2][0] pastryType]) should] equal:theValue(PastryTypeGlazed)];
        });
    });
    
    context(@"When a controller adds pastries", ^{
        MLVCCollectionController *controller = [MLVCCollectionController collectionControllerGroupingByBlock:pastryTypeBlock groupTitleBlock:pastryTypeNameBlock sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"pastryType" ascending:YES]]];

        [controller insertObjects:@[[Pastry pastryNamed:@"Brownie" calories:320 type:PastryTypeChocolate]]];
        [controller insertObjects:@[[Pastry pastryNamed:@"Lemon Tart" calories:230 type:PastryTypeLemon]]];
        it(@"chocolate pastries should come after lemon pastries", ^{
            MLVCCollectionControllerGroup *group = controller[1];
            [[group.id should] equal:@(PastryTypeChocolate)];
        });
        it(@"should then insert a new section at index 0", ^{
            [[[controller[0] id] should] equal:@(PastryTypeLemon)];
        });
    });
});

SPEC_END


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