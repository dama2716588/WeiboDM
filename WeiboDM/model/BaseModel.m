//
// Created by eric on 13-4-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaseModel.h"


@implementation BaseModel {

}
- (id)initWithDictionary:(NSDictionary *)dic {
    if ((self = [super init])) {
        [self setValuesForKeysWithDictionary:dic];
        _keys = [dic allKeys];
    }
    return self;
}

- (NSDictionary *)dic {
    return [self dictionaryWithValuesForKeys:_keys];
}

- (BOOL)allowsKeyedCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // do nothing.
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
    BaseModel *newModel = [[BaseModel allocWithZone:zone] init];
    return newModel;
}

- (id)copyWithZone:(NSZone *)zone {
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
    BaseModel *newModel = [[BaseModel allocWithZone:zone] init];
    return newModel;
}

- (id)valueForUndefinedKey:(NSString *)key {
    // subclass implementation should provide correct key value mappings for custom keys
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // subclass implementation should set the correct key value mappings for custom keys
    if ([key isEqualToString:@"id"])
        self.model_id = [NSString stringWithFormat:@"%@", value];
}

@end
