# Работа с ZFS

## Работа с разными алгоритмами сжатия

Создаем pool

``
zpool create arh mirror sdb sdc
``

Создаем файловую системы для каждого алгоритма сжатия

``
  zfs create arh/fs_gzip
  zfs create arh/fs_gzip_n
  zfs create arh/fs_zle   
  zfs create arh/fs_lz4
``

Задаем для каждой файловой системы свой алгоритм сжатия

``
zfs set compression=gzip arh/fs_gzip
zfs set compression=gzip-9 arh/fs_gzip_n
zfs set compression=zle arh/fs_zle   
zfs set compression=lz4 arh/fs_lz4
``

Загрузив текст "Война и Мир" на каждую фс, мы можем увидеть какой алгоритм лучше сжимает

``
#df
Filesystem     1K-blocks    Used Available Use% Mounted on
devtmpfs          499864       0    499864   0% /dev
tmpfs             507380       0    507380   0% /dev/shm
tmpfs             507380    6888    500492   2% /run
tmpfs             507380       0    507380   0% /sys/fs/cgroup
/dev/sda1       41921540 8647056  33274484  21% /
tmpfs             101480       0    101480   0% /run/user/1000
arh               843904     128    843776   1% /arh
arh/fs_gzip       845056    1280    843776   1% /arh/fs_gzip
arh/fs_gzip_n     845056    1280    843776   1% /arh/fs_gzip_n
arh/fs_zle        847104    3328    843776   1% /arh/fs_zle
arh/fs_lz4        845952    2176    843776   1% /arh/fs_lz4
tmpfs             101480       0    101480   0% /run/user/0
``

``
# du -a /arh
3287	/arh/fs_zle/2600-0.txt
3288	/arh/fs_zle
1239	/arh/fs_gzip_n/2600-0.txt
1239	/arh/fs_gzip_n
1242	/arh/fs_gzip/2600-0.txt
1243	/arh/fs_gzip
2041	/arh/fs_lz4/2600-0.txt
2042	/arh/fs_lz4
7811	/arh
``

## Импорт zfs

Проверяем скачаный pool

``
# zpool import -d ${PWD}/zpoolexport/       
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:
	otus                            ONLINE
	  mirror-0                      ONLINE
	    /vagrant/zpoolexport/filea  ONLINE
	    /vagrant/zpoolexport/fileb  ONLINE
``

Импортируем его

``
# zpool import -d zpoolexport/ otus
``

Смотрим сколько в нем памяти

``
# zpool iostat otus
              capacity     operations     bandwidth 
pool        alloc   free   read  write   read  write
----------  -----  -----  -----  -----  -----  -----
otus        2.09M   478M      0      3  6.41K  18.2K
``

Смотрим параметры

``
# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  2.04M                  -
otus  available             350M                   -
otus  referenced            24K                    -
otus  compressratio         1.00x                  -
otus  mounted               yes                    -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        2.01M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           1020K                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              off                    default
otus  redundant_metadata    all                    default
otus  overlay               off                    default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0 
``

## Восстановление zfs

Скачиваем файл и восстанавливаем из файла снапшот

``
# zfs receive otus/storage@taks2 < /vagrant/otus_task2.file
``

Находим secret_message

``
# cat /otus/storage/task1/file_mess/secret_message
https://github.com/sindresorhus/awesome
``