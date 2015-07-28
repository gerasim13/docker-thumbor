[watcher:thumbor]
cmd = thumbor --port=8000 --conf=/code/thumbor.conf
numprocesses = 1
use_sockets = False
uid = thumbor
gid = thumbor
working_dir = /code
virtualenv = /code/env
copy_env = True
autostart = True

[watcher:thumbor1]
cmd = thumbor --port=8001 --conf=/code/thumbor.conf
numprocesses = 1
use_sockets = False
uid = thumbor1
gid = thumbor1
working_dir = /code
virtualenv = /code/env
copy_env = True
autostart = True

[watcher:thumbor2]
cmd = thumbor --port=8002 --conf=/code/thumbor.conf
numprocesses = 1
use_sockets = False
uid = thumbor2
gid = thumbor2
working_dir = /code
virtualenv = /code/env
copy_env = True
autostart = True

[watcher:thumbor3]
cmd = thumbor --port=8003 --conf=/code/thumbor.conf
numprocesses = 1
use_sockets = False
uid = thumbor3
gid = thumbor3
working_dir = /code
virtualenv = /code/env
copy_env = True
autostart = True
