#!/usr/bin/env fish
if curl --silent https://www.pluckygirl.com | grep -q 'not taking New clients'
  echo '{"text": ""}'
else
  swaynag --message 'Call Plucky Girl!!!'
  echo '{"text": "PG New Patient Opening!!!", "state": "Critical"}'
end
