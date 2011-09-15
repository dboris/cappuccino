var COUNTER;

@implementation CPKVCArrayTest : OJTestCase
{
    TestObject                          _object @accessors(property=object);
    ImplementedTestObject               _implementedObject @accessors(property=implementedObject);
}

- (void)setUp
{
    _object = [[TestObject alloc] init];
    _implementedObject = [[ImplementedTestObject alloc] init];

    COUNTER = 0;
}

- (void)_patchSelector:(SEL)theSelector
{
    var method = class_getInstanceMethod([[self implementedObject] class], theSelector),
        implementation = method_getImplementation(method);

    class_addMethod([[self object] class], theSelector, implementation);
}

- (void)testUsesCountOfKey
{
    [self _patchSelector:@selector(countOfValues)];

    var count = [[[self object] mutableArrayValueForKey:@"values"] count];

    [self assert:10 equals:count message:@"countOfValues should return 10"];
    [self assert:1 equals:COUNTER message:@"countOfValues should have been called once"]
}

- (void)testObjectAtIndexUsesObjectInKeyAtIndex
{
    [self _patchSelector:@selector(objectInValuesAtIndex:)];

    var values = [[self object] mutableArrayValueForKey:@"values"],
        object = [values objectAtIndex:0];

    [self assert:0 equals:object]
    [self assert:1 equals:COUNTER message:@"objectInValuesAtIndex: should have been called once"];
}

- (void)testObjectsAtIndexesUsesObjectInKeyAtIndex
{
    [self _patchSelector:@selector(objectInValuesAtIndex:)];

    var values = [[self object] mutableArrayValueForKey:@"values"],
        objects = [values objectsAtIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, 2)]];

    [self assert:[0, 1] equals:objects]
    [self assert:2 equals:COUNTER message:@"objectInValuesAtIndex: should have been called once"];
}

- (void)testObjectAtIndexUsesKeyAtIndexes
{
    [self _patchSelector:@selector(valuesAtIndexes:)];

    var values = [[self object] mutableArrayValueForKey:@"values"],
        object = [values objectAtIndex:0];

    [self assert:0 equals:object]
    [self assert:1 equals:COUNTER message:@"valuesAtIndexes: should have been called once"];
}

- (void)testObjectsAtIndexesUsesKeyAtIndexes
{
    [self _patchSelector:@selector(valuesAtIndexes:)];

    var values = [[self object] mutableArrayValueForKey:@"values"],
        objects = [values objectsAtIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, 2)]];

    [self assert:[0, 1] equals:objects]
    [self assert:1 equals:COUNTER message:@"valuesAtIndexes: should have been called once"];
}

- (void)testInsertObjectAtIndexUsesInsertKeyAtIndex
{
    [self _patchSelector:@selector(insertObject:inValuesAtIndex:)];

    [[[self object] mutableArrayValueForKey:@"values"] insertObject:11 atIndex:10];

    [self assert:11 equals:[[[self object] values] objectAtIndex:10]];
    [self assert:1 equals:COUNTER message:@"insertObject:inValuesAtIndex: should have been called once"];
}

- (void)testInsertObjectsAtIndexesUsesInsertKeyAtIndex
{
    [self _patchSelector:@selector(insertObject:inValuesAtIndex:)];

    var indexes = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(10, 2)];
    [[[self object] mutableArrayValueForKey:@"values"] insertObjects:[11, 12] atIndexes:indexes];

    [self assert:[11, 12] equals:[[[self object] values] objectsAtIndexes:indexes]];
    [self assert:2
          equals:COUNTER
         message:@"insertValues:atIndexes: should have been called once for each object"];
}

- (void)testInsertObjectAtIndexUsesInsertKeyAtIndexes
{
    [self _patchSelector:@selector(insertValues:atIndexes:)];

    [[[self object] mutableArrayValueForKey:@"values"] insertObject:11 atIndex:10];

    [self assert:11 equals:[[[self object] values] objectAtIndex:10]];
    [self assert:1 equals:COUNTER message:@"insertValues:atIndexes: should have been called once"];
}

- (void)testInsertObjectsAtIndexesUsesInsertKeyAtIndexes
{
    [self _patchSelector:@selector(insertValues:atIndexes:)];

    var indexes = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(10, 2)];
    [[[self object] mutableArrayValueForKey:@"values"] insertObjects:[11, 12] atIndexes:indexes];

    [self assert:[11, 12] equals:[[[self object] values] objectsAtIndexes:indexes]];
    [self assert:1
          equals:COUNTER
         message:@"insertValues:atIndexes: should have been called once for each object"];
}

- (void)testRemoveObjectAtIndexUsesRemoveKeyAtIndex
{
    [self _patchSelector:@selector(removeObjectFromValuesAtIndex:)];

    [[[self object] mutableArrayValueForKey:@"values"] removeObjectAtIndex:0];

    [self assert:[1, 2, 3, 4, 5, 6, 7, 8, 9] equals:[[self object] values]];
    [self assert:1 equals:COUNTER message:@"removeObjectFromValuesAtIndex: should have been called once"];
}

- (void)testRemoveObjectAtIndexesUsesRemoveKeyAtIndex
{
    [self _patchSelector:@selector(removeObjectFromValuesAtIndex:)];

    var indexes = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, 2)];
    [[[self object] mutableArrayValueForKey:@"values"] removeObjectsAtIndexes:indexes];

    [self assert:[2, 3, 4, 5, 6, 7, 8, 9] equals:[[self object] values]];
    [self assert:2 equals:COUNTER message:@"removeValuesAtIndex: should have been called once for each object"];
}

- (void)testRemoveObjectsAtIndexesUsesRemoveKeyAtIndex
{
    [self _patchSelector:@selector(removeValuesAtIndexes:)];

    [[[self object] mutableArrayValueForKey:@"values"] removeObjectAtIndex:0];

    [self assert:[1, 2, 3, 4, 5, 6, 7, 8, 9] equals:[[self object] values]];
    [self assert:1
          equals:COUNTER
         message:@"removeValuesAtIndexes: should have been once for each object"];
}

- (void)testRemoveObjectsAtIndexesUsesRemoveKeyAtIndexes
{
    [self _patchSelector:@selector(removeValuesAtIndexes:)];

    var indexes = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(3, 2)];
    [[[self object] mutableArrayValueForKey:@"values"] removeObjectsAtIndexes:indexes];

    [self assert:[0, 1, 2, 5, 6, 7, 8, 9] equals:[[self object] values]];
    [self assert:1 equals:COUNTER message:@"removeValuesAtIndexes: should have been called once"];
}

- (void)testReplaceObjectAtIndexWithObjectUsesReplaceObjectInKeyAtIndexWithObject
{
    [self _patchSelector:@selector(replaceObjectInValuesAtIndex:withObject:)];

    [[[self object] mutableArrayValueForKey:@"values"] replaceObjectAtIndex:0 withObject:1];

    [self assert:[1, 1, 2, 3, 4, 5, 6, 7, 8, 9] equals:[[self object] values]];
    [self assert:1
          equals:COUNTER
         message:@"replaceObjectInValuesAtIndex:withObject: should have been called once"];
}

- (void)testReplaceObjectsAtIndexesWithObjectsUsesReplaceObjectInKeyAtIndexWithObject
{
    [self _patchSelector:@selector(replaceObjectInValuesAtIndex:withObject:)];

    var indexes = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(5, 3)];
    [[[self object] mutableArrayValueForKey:@"values"] replaceObjectsAtIndexes:indexes withObjects:[1, 2, 3]];

    [self assert:[0, 1, 2, 3, 4, 1, 2, 3, 8, 9] equals:[[self object] values]];
    [self assert:3
          equals:COUNTER
         message:@"replaceObjectInValuesAtIndex:withObject: should have been called once"];
}

- (void)testReplaceObjectAtIndexWithObjectUsesReplaceKeyAtIndexesWithKeys
{
    [self _patchSelector:@selector(replaceValuesAtIndexes:withValues:)];

    [[[self object] mutableArrayValueForKey:@"values"] replaceObjectAtIndex:5 withObject:6];

    [self assert:[0, 1, 2, 3, 4, 6, 6, 7, 8, 9] equals:[[self object] values]];
    [self assert:1
          equals:COUNTER
         message:@"replaceObjectInValuesAtIndex:withObject: should have been called once"];
}

- (void)testReplaceObjectsAtIndexesWithObjectsUsesReplaceKeyAtIndexesWithKeys
{
    [self _patchSelector:@selector(replaceValuesAtIndexes:withValues:)];

    var indexes = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(6, 2)];
    [[[self object] mutableArrayValueForKey:@"values"] replaceObjectsAtIndexes:indexes withObjects:[7, 8]];

    [self assert:[0, 1, 2, 3, 4, 5, 7, 8, 8, 9] equals:[[self object] values]];
    [self assert:1
          equals:COUNTER
         message:@"replaceObjectInValuesAtIndexes:withValues: should have been called once"];
}

@end

@implementation TestObject : CPObject
{
    CPArray                     _values @accessors(property=values);
}

- (id)init
{
    if (self = [super init])
    {
        _values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    }

    return self;
}

@end

@implementation ImplementedTestObject : TestObject
{
}

- (int)countOfValues
{
    // CPLog.warn(@"countOfValues");

    COUNTER += 1;
    return [[self values] count];
}

- (id)objectInValuesAtIndex:(int)theIndex
{
    // CPLog.warn(@"objectInValuesAtIndex: %@", theIndex);

    COUNTER += 1;
    return [[self values] objectAtIndex:theIndex];
}

- (CPArray)valuesAtIndexes:(CPIndexSet)theIndexes
{
    // CPLog.warn(@"valuesAtIndexes: %@", theIndexes);

    COUNTER += 1;
    return [[self values] objectsAtIndexes:theIndexes];
}

- (void)insertObject:(id)theObject inValuesAtIndex:(int)theIndex
{
    // CPLog.warn(@"insertObject: %@ inValuesAtIndex: %@", theObject, theIndex);

    COUNTER += 1;
    [[self values] insertObject:theObject atIndex:theIndex];
}

- (void)insertValues:(CPArray)theObjects atIndexes:(CPIndexSet)theIndexes
{
    // CPLog.warn(@"insertValues: %@ atIndexes: %@", theObjects, theIndexes);

    COUNTER += 1;
    [[self values] insertObjects:theObjects atIndexes:theIndexes];
}

- (void)removeObjectFromValuesAtIndex:(int)theIndex
{
    // CPLog.warn(@"removeObjectFromValuesAtIndex: %@", theIndex);

    COUNTER += 1;
    [[self values] removeObjectAtIndex:theIndex];
}

- (void)removeValuesAtIndexes:(CPIndexSet)theIndexes
{
    // CPLog.warn(@"removeValuesAtIndexes: %@", theIndexes);

    COUNTER += 1;
    [[self values] removeObjectsAtIndexes:theIndexes];
}

- (void)replaceObjectInValuesAtIndex:(int)theIndex withObject:(id)theObject
{
    // CPLog.warn(@"replaceObjectInValuesAtIndex: %@ withObject: %@", theIndex, theObject);

    COUNTER += 1;
    [[self values] replaceObjectAtIndex:theIndex withObject:theObject];
}

- (void)replaceValuesAtIndexes:(CPIndexSet)theIndexes withValues:(id)theObjects
{
    // CPLog.warn(@"replaceValuesAtIndexes: %@ withValues: %@", theIndexes, theObjects);

    COUNTER += 1;
    [[self values] replaceObjectsAtIndexes:theIndexes withObjects:theObjects];
}

@end