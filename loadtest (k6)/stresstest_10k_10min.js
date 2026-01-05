import http from 'k6/http';
import { check } from 'k6';

// Testinstellingen
export const options = {
  thresholds: {
    http_req_duration: ['p(95)<3000'], // 95% van de requests moet sneller zijn dan 3s
    http_req_failed: ['rate<0.05'],    // Minder dan 5% fouten toegestaan
  },

  scenarios: {
    contacts: {
      executor: 'ramping-arrival-rate', // We sturen een bepaald aantal requests per minuut
      startRate: 0,                     // Begin met 0 requests
      timeUnit: '1m',                   // Target is "per minuut"

      // Load schema
      stages: [
        { duration: '3m', target: 5000 },  // Ga naar 5.000 req/min in 3 min
        { duration: '5m', target: 10000 }, // Houd 10.000 req/min voor 5 min
        { duration: '2m', target: 0 },     // Bouw in 2 min af naar 0
      ],

      preAllocatedVUs: 1000, // Vooraf gereserveerde virtuele users
      maxVUs: 10000,         // Maximaal aantal virtuele users
    },
  },
};

// Dit draait elke keer dat een request wordt gedaan
export default function () {
  // Doe een GET request naar de loadtest endpoint
  const res = http.get(
    'http://booomtag-dev-alb-1406895298.eu-central-1.elb.amazonaws.com/loadtest'
  );

  // Check of de response status 200 is
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
}
