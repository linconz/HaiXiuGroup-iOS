//
//  User.m
//  HaiXiuGroup
//
//  Created by zhang on 14-3-16.
//  Copyright (c) 2014年 zhang. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId          = _userId;
@synthesize alt             = _alt;
@synthesize name            = _name;
@synthesize avatar          = _avatar;
@synthesize isSuicide       = _isSuicide;


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self){
        self.userId         = [coder decodeObjectForKey:@"userId"];
        self.alt            = [coder decodeObjectForKey:@"alt"];
        self.name           = [coder decodeObjectForKey:@"name"];
        self.avatar         = [coder decodeObjectForKey:@"avatar"];
        self.isSuicide      = [coder decodeBoolForKey:@"isSuicide"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.alt forKey:@"alt"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeBool:self.isSuicide forKey:@"isSuicide"];
}

- (id)copyWithZone:(NSZone *)zone
{
    User *user = [[User alloc] init];
    user.userId = self.userId;
    user.alt = self.alt;
    user.name = self.name;
    user.avatar = self.avatar;
    user.isSuicide = self.isSuicide;
    return user;
}

@end
