/*
uTorrentConstants.h
Copyright (c) 2010, "Claudio Marforio - Mike Godenzi" (<marforio@gmail.com - godenzim@gmail.com>)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

+ Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

+ Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

+ Neither the name of the <ORGANIZATION> nor the names of its contributors may
be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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
	T_DOWNLOAD_PROBLEM = 5,
	T_ADD = 6,
	T_TOKEN = 7
} RESPONSE_TYPE;

typedef enum _SETTINGS_TAG {
	ADDRESS_TAG = 0,
	PORT_TAG = 1,
	UNAME_TAG = 2,
	PWD_TAG = 3,
	ACCOUNT_NAME_TAG = 4
} SETTINGS_TAG;

typedef enum _TORRENT_SITES {
	MININOVA = 0,
	EZTV = 1,
	TORRENTZ = 2
} TORRENT_SITES;