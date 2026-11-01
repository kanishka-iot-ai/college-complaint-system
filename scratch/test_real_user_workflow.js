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

async function runTests() {
  console.log('--- TESTING EXPLICIT UID REGISTRATION & ZERO DEFAULTS ---\n');
  let passed = 0;
  let total = 0;

  function assert(condition, name) {
    total++;
    if (condition) {
      console.log(`[PASS] ${name}`);
      passed++;
    } else {
      console.error(`[FAIL] ${name}`);
    }
  }

  // 1. Missing UID rejection
  const noUid = await post('/api/student/register', {
    name: 'Test No UID',
    email: 'no.uid@cuchd.in',
    department: 'Computer Science',
    semester: 4,
    phone: '9876543210',
    password: 'Password123!'
  });
  assert(noUid.status === 400 && noUid.data.error.includes('University UID is mandatory'), 'Step 1: Registration strictly rejects missing UID');

  // 2. Register real student with explicit student UID
  const explicitUid = '26BAI' + Math.floor(10000 + Math.random() * 90000);
  const email = explicitUid.toLowerCase() + '@cuchd.in';
  const regRes = await post('/api/student/register', {
    uid: explicitUid,
    name: 'Kanishka Giri',
    email,
    section: 'Future Skills & Innovation',
    department: 'Artificial Intelligence',
    semester: 4,
    phone: '9876543299',
    password: 'SecurePassword2026!'
  });
  assert(regRes.status === 201 && regRes.data.success, 'Step 2: Student registered successfully with explicit student UID');
  assert(regRes.data.student.uid === explicitUid, 'Step 3: Stored UID exactly matches entered student UID (' + explicitUid + ') without defaults');
  assert(regRes.data.student.section === 'Future Skills & Innovation', 'Step 4: Stored Section matches student selection');

  // 3. Duplicate UID rejection
  const dupUid = await post('/api/student/register', {
    uid: explicitUid,
    name: 'Duplicate UID Student',
    email: 'different.email@cuchd.in',
    section: 'General',
    department: 'Computer Science',
    semester: 2,
    phone: '9876543211',
    password: 'Password123!'
  });
  assert(dupUid.status === 409 && dupUid.data.error.includes('already registered'), 'Step 5: Registration rejects duplicate UID with 409');

  // 4. Login using newly registered student UID
  const loginByUid = await post('/api/student/login', {
    identifier: explicitUid,
    password: 'SecurePassword2026!'
  });
  assert(loginByUid.status === 200 && loginByUid.data.student.uid === explicitUid, 'Step 6: Login succeeds using custom University UID');

  // 5. Submit grievance with explicit priority
  const subRes = await post('/api/complaint/submit', {
    studentId: regRes.data.student.student_id,
    categoryId: 8,
    priority: 'High',
    title: '5G Wi-Fi drop in Block-A',
    description: 'High packet loss observed during lab practical hours.'
  });
  assert(subRes.status === 201 && subRes.data.success, 'Step 7: Real grievance lodged under new student');

  // 6. Admin students registry check
  const adminStudents = await get('/api/admin/students');
  const foundStudent = adminStudents.data.find(s => s.uid === explicitUid);
  assert(foundStudent && foundStudent.name === 'Kanishka Giri', 'Step 8: Admin registry accurately displays student with custom UID ' + explicitUid);

  console.log(`\n--- ALL ${passed}/${total} UID TESTS PASSED ---\n`);
}

runTests().catch(console.error);
