const http = require('http');

function post(path, body) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify(body);
    const req = http.request({
      hostname: 'localhost',
      port: 3000,
      path,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data)
      }
    }, res => {
      let raw = '';
      res.on('data', c => raw += c);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(raw) });
        } catch (e) {
          resolve({ status: res.statusCode, raw });
        }
      });
    });
    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

function get(path) {
  return new Promise((resolve, reject) => {
    http.get('http://localhost:3000' + path, res => {
      let raw = '';
      res.on('data', c => raw += c);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(raw) });
        } catch (e) {
          resolve({ status: res.statusCode, raw });
        }
      });
    }).on('error', reject);
  });
}

async function run() {
  console.log('--- TESTING PERSISTENCE & RESILIENT LOGIN FLOW ---\n');
  let passed = 0;
  let total = 0;

  function assert(cond, name) {
    total++;
    if (cond) {
      console.log(`[PASS] ${name}`);
      passed++;
    } else {
      console.error(`[FAIL] ${name}`);
    }
  }

  // 1. Direct login test with localAccount re-hydration
  // Simulating a student whose server instance was cold-started / restarted
  const coldUid = '26BAI' + Math.floor(10000 + Math.random() * 90000);
  const localAccount = {
    uid: coldUid,
    name: 'Persistent Student',
    email: coldUid.toLowerCase() + '@cuchd.in',
    department: 'Cyber Security',
    semester: 4,
    section: 'Future Skills & Innovation',
    phone: '9876543299',
    password: 'SecurePass99!'
  };

  // Attempt login with localAccount passed as fallback
  const rehydrateLogin = await post('/api/student/login', {
    identifier: coldUid,
    password: 'SecurePass99!',
    localAccount
  });
  assert(rehydrateLogin.status === 200 && rehydrateLogin.data.success, 'Step 1: Resilient login auto-rehydrates student if cold-started');
  assert(rehydrateLogin.data.student.uid === coldUid, 'Step 2: Returned student matches expected custom UID ' + coldUid);

  // 2. Second login without fallback (should now be in memory)
  const regularLogin = await post('/api/student/login', {
    identifier: coldUid,
    password: 'SecurePass99!'
  });
  assert(regularLogin.status === 200 && regularLogin.data.success, 'Step 3: Subsequent regular login succeeds without needing re-registration');

  // 3. Test explicit /api/student/sync
  const syncUid = '26BCY' + Math.floor(10000 + Math.random() * 90000);
  const syncRes = await post('/api/student/sync', {
    student: {
      uid: syncUid,
      name: 'Synced Student',
      email: syncUid.toLowerCase() + '@cuchd.in',
      department: 'Cyber Security',
      semester: 3,
      section: 'Future Skills & Innovation',
      password: 'SyncPass123!'
    }
  });
  assert(syncRes.status === 200 && syncRes.data.success, 'Step 4: Explicit /api/student/sync registers student cleanly');

  // Verify login for synced student
  const syncLogin = await post('/api/student/login', {
    identifier: syncUid,
    password: 'SyncPass123!'
  });
  assert(syncLogin.status === 200 && syncLogin.data.student.uid === syncUid, 'Step 5: Synced student logs in immediately');

  console.log(`\n--- ALL ${passed}/${total} PERSISTENCE TESTS PASSED ---\n`);
}

run().catch(console.error);
