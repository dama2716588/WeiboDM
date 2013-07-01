//
// Created by eric on 13-4-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BaseModel : NSObject <NSCoding, NSCopying, NSMutableCopying> {
    NSArray *_keys;
}
@property(nonatomic, strong) NSString *model_id;
@property(nonatomic, strong) NSString *updated_at;
@property(nonatomic, strong) NSString *created_at;
- (id)initWithDictionary:(NSDictionary *)dic;
- (NSDictionary *)dic;
@end