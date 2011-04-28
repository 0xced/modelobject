#import "NSObject+Subclasses.h"
#import <objc/runtime.h>

@implementation NSObject (Subclasses)

+ (NSSet *) subclasses
{
	static NSMutableDictionary *cache = nil;
	if (cache == nil)
		cache = [[NSMutableDictionary alloc] init];
	
	NSSet *cachedSubclasses = [cache objectForKey:self];
	if (cachedSubclasses != nil)
		return cachedSubclasses;
	
	NSMutableSet *subclasses = [NSMutableSet set];
	
	int count = objc_getClassList(NULL, 0);
	Class *classes = malloc(sizeof(Class) * count);
	objc_getClassList(classes, count);
	for (int i = 0; i < count; i++)
	{
		Class class = classes[i];
		if (class != self && class_getClassMethod(class, @selector(isSubclassOfClass:)) && [class isSubclassOfClass:self])
			[subclasses addObject:class];
	}
	free(classes);
	
	[cache setObject:subclasses forKey:self];
	
	return subclasses;
}

@end
