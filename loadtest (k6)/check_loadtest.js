import http from 'k6/http';
import { check, sleep } from 'k6';

const BASE_URL = 'http://booomtag-dev-alb-1902112912.eu-central-1.elb.amazonaws.com';

export const options = {
  stages: [
    { duration: '1m', target: 50 },   // rustig opbouwen
    { duration: '1m', target: 100 },  // medium
    { duration: '2m', target: 200 },  // zware load
    { duration: '1m', target: 0 },    // afbouwen
  ],
};

export default function () {
  const res = http.get(BASE_URL);

  check(res, {
    'status is 200': (r) => r.status === 200,
  });

  sleep(1);
}