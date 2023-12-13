//
//  Task+CoreDataProperties.h
//  Tasks-C
//
//  Created by Nikits Panaskin on 13.12.2023.
//
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *category;
@property (nonatomic) BOOL completed;

@end

NS_ASSUME_NONNULL_END
