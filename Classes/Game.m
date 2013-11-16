//
//  Game.m
//  Nestopia
//
//  Created by Nick Tymchenko on 11/15/13.
//
//

#import "Game.h"
#import "EmulatorCore.h"

@implementation Game

#pragma mark Properties

@dynamic settings;

- (NSDictionary *)settings {
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:[self settingsKey]];
    return settings ?: [EmulatorCore globalSettings];
}

- (void)setSettings:(NSDictionary *)settings {
    if (settings) {
        [[NSUserDefaults standardUserDefaults] setObject:settings forKey:[self settingsKey]];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self settingsKey]];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// TODO: favorite, saved

#pragma mark Init

- (id)initWithTitle:(NSString *)title path:(NSString *)path savePath:(NSString *)savePath {
    if ((self = [super init])) {
        _title = title;
        _path = path;
        _savePath = savePath;
    }
    return self;
}

#pragma mark Public

+ (NSArray *)gamesList {
    NSMutableArray *games = [NSMutableArray array];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [searchPaths lastObject];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];
    NSString *filename;
    
    while ((filename = [enumerator nextObject])) {
        if ([[[filename pathExtension] lowercaseString] isEqualToString:@"nes"]) {
            NSString *title = [[filename lastPathComponent] stringByDeletingPathExtension];
            NSString *path = [documentsPath stringByAppendingPathComponent:filename];
            NSString *savePath = [path stringByAppendingPathExtension:@"sav"];
            
            Game *game = [[Game alloc] initWithTitle:title path:path savePath:savePath];
            [games addObject:game];
        }
    }
    
    return games;
}

#pragma mark Private

- (NSString *)settingsKey {
    return [NSString stringWithFormat:@"Games.%@.settings", self.title];
}

@end