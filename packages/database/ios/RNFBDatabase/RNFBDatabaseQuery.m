//
/**
 * Copyright (c) 2016-present Invertase Limited & Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this library except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "RNFBDatabaseQuery.h"

static __strong FIRDatabaseQuery *query;
static __strong NSMutableDictionary  *listeners;

@implementation RNFBDatabaseQuery

- (id)init {
  self = [super init];
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    query = [FIRDatabaseQuery alloc];
    listeners = [[NSMutableDictionary  alloc] init];
  });
  return self;
}

- (RNFBDatabaseQuery *)initWithReferenceAndModifiers
    :(FIRDatabaseReference *)reference
    modifiers:(NSArray *)modifiers {
  self = [super init];

  if (self) {
    query = [self buildQueryWithModifiers:reference modifiers:modifiers];
  }

  return self;
}

- (FIRDatabaseQuery *)buildQueryWithModifiers
    :(FIRDatabaseReference *)reference
    modifiers:(NSArray *)modifiers {
  FIRDatabaseQuery *query = reference;

  for (NSDictionary *modifier in modifiers) {
    NSString *type = [modifier valueForKey:@"type"];
    NSString *name = [modifier valueForKey:@"name"];

    if ([type isEqualToString:@"orderBy"]) {
      if ([name isEqualToString:@"orderByKey"]) {
        query = [query queryOrderedByKey];
      } else if ([name isEqualToString:@"orderByPriority"]) {
        query = [query queryOrderedByPriority];
      } else if ([name isEqualToString:@"orderByValue"]) {
        query = [query queryOrderedByValue];
      } else if ([name isEqualToString:@"orderByChild"]) {
        NSString *key = [modifier valueForKey:@"key"];
        query = [query queryOrderedByChild:key];
      }
    } else if ([type isEqualToString:@"limit"]) {
      NSUInteger limit = [[modifier valueForKey:@"value"] unsignedIntValue];

      if ([name isEqualToString:@"limitToLast"]) {
        query = [query queryLimitedToLast:limit];
      } else if ([name isEqualToString:@"limitToFirst"]) {
        query = [query queryLimitedToFirst:limit];
      }
    } else if ([type isEqualToString:@"filter"]) {
      NSString *valueType = [modifier valueForKey:@"valueType"];
      NSString *key = [modifier valueForKey:@"key"];

      if ([name isEqualToString:@"startAt"]) {
        if ([valueType isEqualToString:@"null"]) {
          if (key != nil) {
            query = [query queryStartingAtValue:[NSNull null] childKey:key];
          } else {
            query = [query queryStartingAtValue:[NSNull null]];
          }
        } else {
          id value = [self getIdValue:[modifier valueForKey:@"value"] type:valueType];

          if (key != nil) {
            query = [query queryStartingAtValue:value childKey:key];
          } else {
            query = [query queryStartingAtValue:value];
          }
        }
      } else if ([name isEqualToString:@"endAt"]) {
        if ([valueType isEqualToString:@"null"]) {
          if (key != nil) {
            query = [query queryEndingAtValue:[NSNull null] childKey:key];
          } else {
            query = [query queryEndingAtValue:[NSNull null]];
          }
        } else {
          id value = [self getIdValue:[modifier valueForKey:@"value"] type:valueType];

          if (key != nil) {
            query = [query queryEndingAtValue:value childKey:key];
          } else {
            query = [query queryEndingAtValue:value];
          }
        }
      }
    }
  }

  return query;
}

- (id)getIdValue:(NSString *)value type:(NSString *)type {
  if ([type isEqualToString:@"number"]) {
    return @(value.doubleValue);
  } else if ([type isEqualToString:@"boolean"]) {
    return @(value.boolValue);
  } else {
    return value;
  }
}

+ (BOOL)hasEventListener:(NSString *)eventRegistrationKey {
  return listeners[eventRegistrationKey] != nil;
}

+ (BOOL)hasListeners {
  return [[listeners allKeys] count] > 0;
}

@end
