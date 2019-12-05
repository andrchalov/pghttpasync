
import sys
import select
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2 import sql
import json
import logging
import requests
import os

PG_CHANNEL = "pghttpasync"
logger = logging.getLogger("main")
logging.basicConfig(stream=sys.stdout, level=os.getenv('LOGLEVEL', 'INFO'))

conn = psycopg2.connect("")
conn.autocommit = True

curs = conn.cursor(cursor_factory=RealDictCursor)

logging.debug("Start listening channel %s" % PG_CHANNEL)
curs.execute(sql.SQL('LISTEN {};').format(sql.Identifier(PG_CHANNEL)))

logging.debug("Waiting for notifications on channel %s" % PG_CHANNEL)

while True:
  logging.debug(u'Fetching new job')
  curs.execute('SELECT * FROM pghttpasync.worker_job_take()')
  res = curs.fetchone()

  if res:
    logging.debug(u'Having new job')
    try:
      r = requests.request(res["method"], res["url"], data=res["body"], headers=res["headers"], params=res["args"])
      data = json.dumps({'status': r.status_code, 'body': r.text, 'headers': dict(r.headers)})
      curs.execute('SELECT pghttpasync.worker_job_complete(%s::int, %s)', (res['id'], data))
      continue
    except requests.exceptions.RequestException as e:
      curs.execute('SELECT pghttpasync.worker_job_failed(%s::int, %s::text)', (res['id'], str(e)))

  else:
    logging.debug(u'No new jobs')

  wait = True
  while wait:
    if select.select([conn],[],[],30) == ([],[],[]):
      logging.debug(u'Timeout')
      wait = False
    else:
      conn.poll()
      while conn.notifies:
        notify = conn.notifies.pop(0)
        logging.debug(u'Getting notification %s', notify.channel)
        wait = False
        break
