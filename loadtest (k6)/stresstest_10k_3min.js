import http from 'k6/http';
import { check, sleep } from 'k6';

// Voeg de Application Load Balancer URL toe bij elke nieuwe deploy
const BASE_URL = 'http://booomtag-dev-alb-828796772.eu-central-1.elb.amazonaws.com/loadtest'; 

export const options = {
  thresholds: {
    // Performance criteria voor de test
    http_req_receiving: ['p(95)<3000'],
    http_req_duration: ['p(95)<3000'],
    http_req_failed: ['rate<0.01'],
  },

  scenarios: {
    contacts: {
      executor: 'ramping-arrival-rate', 
      startRate: 0,  
      timeUnit: '1m', 
      preAllocatedVUs: 1000, 
      maxVUs: 10000,  
      stages: [
        { duration: '3m', target: 10000 },  
      ],
      exec: 'hitroot',
    },
  },
};

export function hitroot() {
  const res = http.get(BASE_URL);

  // Controleer of de response succesvol is
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time <= 3s': (r) => r.timings.duration <= 3000,
  });
  // Wacht 1 seconde tussen requests
  sleep(1);
}
