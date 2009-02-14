//
//  uTorrentConstants.h
//  uTorrentView
//
//  Created by Claudio Marforio on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _TORRENTS_ARRAY {
	HASH = 0,
	STATUS = 1,
	NAME = 2,
	SIZE = 3,
	PERCENT_PROGRESS = 4,
	DOWNLOADED = 5,
	UPLOADED = 6,
	RATIO = 7,
	UPLOAD_SPEED = 8,
	DOWNLOAD_SPEED = 9,
	ETA = 10,
	LABEL = 11,
	PEERS_CONNECTED = 12,
	PEERS_IN_SWARM = 13,
	SEEDS_CONNECTED = 14,
	SEEDS_IN_SWARM = 15,
	AVAILABILITY = 16,
	TORRENT_QUEUE_ORDER = 17,
	REMAINING = 18
} TORRENTS_ARRAY;

typedef enum _TORRENTS_STATUS {
	STARTED = 0,
	PAUSED = 1,
	CHECKING = 2,
	ERROR = 3,
	QUEUED = 4,
	STOPPED = 5,
	FINISHED = 6,
	SEEDING = 7,
	LEECHING = 8
} TORRENTS_STATUS;
	
typedef enum _RESPONSE_TYPE {
	T_LIST = 0,
	T_START = 1,
	T_STOP = 2,
	T_DELETE = 3,
	T_NETWORK_PROBLEM = 4,
	T_DOWNLOAD_PROBLEM = 5
} RESPONSE_TYPE;

typedef enum _SETTINGS_TAG {
	ADDRESS_TAG = 0,
	PORT_TAG = 1,
	UNAME_TAG = 2,
	PWD_TAG = 3
} SETTINGS_TAG;