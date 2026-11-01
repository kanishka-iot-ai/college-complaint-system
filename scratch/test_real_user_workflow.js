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
  console.log('--- STARTING REAL USER WORKFLOW VERIFICATION ---\n');
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

  // 1. Register a real student
  const email = 'kanishka.student.' + Date.now() + '@cuchd.in';
  const regRes = await post('/api/student/register', {
    name: 'Kanishka Giri',
    email,
    department: 'Artificial Intelligence',
    semester: 5,
    phone: '9876543299',
    password: 'SecurePassword2026!'
  });
  assert(regRes.status === 201 && regRes.data.success, 'Step 1: Student registration API returns 201 Created');
  const student = regRes.data.student;
  assert(student && student.student_id > 20, 'Step 2: New student assigned unique incremental student_id');

  // 2. Duplicate email rejection
  const dupRes = await post('/api/student/register', {
    name: 'Duplicate Test',
    email,
    department: 'Computer Science',
    semester: 1,
    phone: '9876543200',
    password: 'Password123!'
  });
  assert(dupRes.status === 409 && !dupRes.data.success, 'Step 3: Registration rejects duplicate email with 409 Conflict');

  // 3. Login with wrong password
  const failLogin = await post('/api/student/login', {
    identifier: email,
    password: 'WrongPassword!'
  });
  assert(failLogin.status === 401 && !failLogin.data.success, 'Step 4: Login rejects invalid password with 401');

  // 4. Login with correct password
  const okLogin = await post('/api/student/login', {
    identifier: email,
    password: 'SecurePassword2026!'
  });
  assert(okLogin.status === 200 && okLogin.data.success, 'Step 5: Student login succeeds with valid credentials');
  assert(okLogin.data.student.email === email, 'Step 6: Login response returns safe student record');

  // 5. Initial dashboard check
  const dashRes = await get('/api/student/dashboard?studentId=' + student.student_id);
  assert(dashRes.status === 200 && dashRes.data.stats.total === 0, 'Step 7: New student initial dashboard shows 0 complaints');

  // 6. Submit a real grievance
  const subRes = await post('/api/complaint/submit', {
    studentId: student.student_id,
    categoryId: 8, // Internet
    priority: 'High',
    title: '5G Wi-Fi AP signal drop in Academic Block 3',
    description: 'Wi-Fi connection continuously resets during lab simulation hours between 2 PM and 5 PM.'
  });
  assert(subRes.status === 201 && subRes.data.success, 'Step 8: Real grievance lodged successfully with 201');
  const complaintId = subRes.data.complaintId;
  assert(complaintId > 8, 'Step 9: Assigned incremental complaint ID: ' + complaintId);

  // 7. Check student complaints list
  const listRes = await get('/api/student/complaints?studentId=' + student.student_id);
  assert(listRes.status === 200 && listRes.data.length === 1, 'Step 10: Student complaints list returns 1 active complaint');
  assert(listRes.data[0].complaint_id === complaintId, 'Step 11: Correct complaint ID linked to student');

  // 8. Admin login
  const adminLogin = await post('/api/admin/login', {
    email: 'admin@college.edu',
    password: 'password123'
  });
  assert(adminLogin.status === 200 && adminLogin.data.success, 'Step 12: Admin authentication succeeds');

  // 9. Admin view complaints
  const adminList = await get('/api/admin/complaints');
  const found = adminList.data.find(c => c.complaint_id === complaintId);
  assert(found && found.status === 'Submitted', 'Step 13: Admin dashboard lists new grievance under Submitted');

  // 10. Admin update status to In Progress
  const updateRes1 = await post('/api/admin/updateComplaint', {
    complaintId,
    newStatus: 'In Progress',
    assignedDepartment: 'Network Operations Cell',
    remarks: 'Dispatched telecom engineer to calibrate Wi-Fi access points.'
  });
  assert(updateRes1.status === 200 && updateRes1.data.complaint.status === 'In Progress', 'Step 14: Status updated to In Progress with assigned department');

  // 11. Admin resolve complaint with ATR
  const updateRes2 = await post('/api/admin/updateComplaint', {
    complaintId,
    newStatus: 'Resolved',
    remarks: 'Upgraded access point antennas and updated firmware. Signal strength certified at -42 dBm.'
  });
  assert(updateRes2.status === 200 && updateRes2.data.complaint.status === 'Resolved', 'Step 15: Status updated to Resolved with certified ATR');

  // 12. Verify complaint detail endpoint
  const detailRes = await get('/api/complaint/' + complaintId);
  assert(detailRes.status === 200 && detailRes.data.status === 'Resolved', 'Step 16: Complaint detail reflects Resolved status');
  assert(detailRes.data.resolution && detailRes.data.resolution.remarks.includes('Upgraded access point'), 'Step 17: Official ATR recorded in complaint resolution');
  assert(detailRes.data.history.length === 2, 'Step 18: Full audit history recorded 2 transitions');

  // 13. Admin students list contains new student
  const studentsRes = await get('/api/admin/students');
  const studentFound = studentsRes.data.find(s => s.student_id === student.student_id);
  assert(studentFound && studentFound.name === 'Kanishka Giri', 'Step 19: Real student enrolled and visible in Admin Student Registry');

  // 14. Update student profile
  const profileUp = await post('/api/student/profile', {
    studentId: student.student_id,
    name: 'Kanishka Giri (Updated)',
    department: 'Artificial Intelligence',
    semester: 6,
    phone: '9876543200'
  });
  assert(profileUp.status === 200 && profileUp.data.student.name === 'Kanishka Giri (Updated)', 'Step 20: Student profile successfully updated and persisted');

  console.log(`\n--- TEST RESULTS: ${passed}/${total} PASSED ---`);
}

runTests().catch(console.error);
