//
//  Task+CoreDataProperties.m
//  Tasks-C
//
//  Created by Nikits Panaskin on 13.12.2023.
//
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Task"];
}

@dynamic name;
@dynamic category;
@dynamic completed;

@end
