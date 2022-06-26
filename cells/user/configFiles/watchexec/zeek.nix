{
  watchexec,
  endpoint,
}: ''
  ${watchexec}/bin/watchexec /var/lib/zeek/spool/zeek \
            -- bash -c 'vast --endpoint=${endpoint} --plugins=all import zeek < /var/lib/zeek/spool/zeek'
''
