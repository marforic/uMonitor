@class TorrentNetworkManager;

@protocol TorrentOrganizer

- (NSArray *)getOrganizedTorrents;
- (void)organize;
- (id)initWithTNM:(TorrentNetworkManager *)networkManager;
- (NSString *)getTitleForSection:(NSInteger)section;
- (NSInteger)getSectionNumber;
- (NSInteger)getRowNumberInSection:(NSInteger)section;
- (NSArray *)getItemInPath:(NSIndexPath *)path;
- (void)dealloc;
- (NSString *)getLabelText;

@end
