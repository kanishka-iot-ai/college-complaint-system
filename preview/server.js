const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = process.env.PORT || 3000;
const PUBLIC_DIR = path.join(__dirname, 'public');

// --- In-Memory Relational Database (Seeded from college_complaint_db.sql) ---
const db = {
    students: [
        { student_id: 1, uid: '26BAI10196', name: 'MOHAMMED TEHJIB NIZAM CHOWDHURY', email: '26BAI10196@cuchd.in', section: 'Future Skills & Innovation', department: 'Computer Science', semester: 4, is_active: true, created_at: '2026-10-25' },
        { student_id: 2, uid: '25BCY70275', name: 'PIYESH KUMAR DAS', email: '25BCY70275@cuchd.in', section: 'Future Skills & Innovation', department: 'Cyber Security', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 3, uid: '26BAI10195', name: 'Singiri sireesha', email: '26BAI10195@cuchd.in', section: 'Future Skills & Innovation', department: 'Artificial Intelligence', semester: 4, is_active: true, created_at: '2026-10-25' },
        { student_id: 4, uid: '26BAI10118', name: 'APARAJITA GOPE ARPA', email: '26BAI10118@cuchd.in', section: 'Future Skills & Innovation', department: 'Artificial Intelligence', semester: 4, is_active: true, created_at: '2026-10-25' },
        { student_id: 5, uid: '26BDS80005', name: 'AYUSH KUMAR PATEL', email: '26BDS80005@cuchd.in', section: 'Future Skills & Innovation', department: 'Data Science', semester: 4, is_active: true, created_at: '2026-10-25' },
        { student_id: 6, uid: '26BDS80004', name: 'MD RAZAUDDIN', email: '26BDS80004@cuchd.in', section: 'Future Skills & Innovation', department: 'Data Science', semester: 4, is_active: true, created_at: '2026-10-25' },
        { student_id: 7, uid: '26BAI80018', name: 'VIDHITA CHAUDHARY', email: '26BAI80018@cuchd.in', section: 'Future Skills & Innovation', department: 'Artificial Intelligence', semester: 4, is_active: true, created_at: '2026-10-25' },
        { student_id: 8, uid: '25BAI70994', name: 'MEHAKPREET KAUR', email: '25BAI70994@cuchd.in', section: 'Future Skills & Innovation', department: 'Artificial Intelligence', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 9, uid: '25BDA70080', name: 'RIKSHESH SINGH', email: '25BDA70080@cuchd.in', section: 'Future Skills & Innovation', department: 'Big Data Analytics', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 10, uid: '25BCC70040', name: 'DHRUV', email: '25BCC70040@cuchd.in', section: 'Future Skills & Innovation', department: 'Cloud Computing', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 11, uid: '25BCY70056', name: 'NAVEEN CHAUDHARY', email: '25BCY70056@cuchd.in', section: 'Future Skills & Innovation', department: 'Cyber Security', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 12, uid: '25BAI70221', name: 'VIPLAV MITTAL', email: '25BAI70221@cuchd.in', section: 'Future Skills & Innovation', department: 'Artificial Intelligence', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 13, uid: '25BDA70085', name: 'SAHIL KUMAR DOGRA', email: '25BDA70085@cuchd.in', section: 'Future Skills & Innovation', department: 'Big Data Analytics', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 14, uid: '25BDA70265', name: 'KRIPANSHU SIKDAR', email: '25BDA70265@cuchd.in', section: 'Future Skills & Innovation', department: 'Big Data Analytics', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 15, uid: '25BAI70939', name: 'VIKALP ANGROYA', email: '25BAI70939@cuchd.in', section: 'Society, Sustainability & Human Values', department: 'Artificial Intelligence', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 16, uid: '25IBD70002', name: 'AMAN KUMARI', email: '25IBD70002@cuchd.in', section: 'Future Skills & Innovation', department: 'Integrated Big Data', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 17, uid: '25BCY70007', name: 'SAKSHAM KAPATIA', email: '25BCY70007@cuchd.in', section: 'Future Skills & Innovation', department: 'Cyber Security', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 18, uid: '25BDA70014', name: 'SUKRIT SONI', email: '25BDA70014@cuchd.in', section: 'Future Skills & Innovation', department: 'Big Data Analytics', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 19, uid: '25BAI70107', name: 'ABHICHAL VERMA', email: '25BAI70107@cuchd.in', section: 'Future Skills & Innovation', department: 'Artificial Intelligence', semester: 5, is_active: true, created_at: '2026-10-25' },
        { student_id: 20, uid: '25BDA70106', name: 'PRATHAM DOGRA', email: '25BDA70106@cuchd.in', section: 'Future Skills & Innovation', department: 'Big Data Analytics', semester: 5, is_active: true, created_at: '2026-10-25' }
    ],
    admins: [
        { admin_id: 1, name: 'Super Admin', email: 'admin@college.edu' },
        { admin_id: 2, name: 'Department Admin', email: 'dept@college.edu' }
    ],
    categories: [
        { category_id: 1, category_name: 'Classroom' },
        { category_id: 2, category_name: 'Laboratory' },
        { category_id: 3, category_name: 'Library' },
        { category_id: 4, category_name: 'Hostel' },
        { category_id: 5, category_name: 'Washroom' },
        { category_id: 6, category_name: 'Electricity' },
        { category_id: 7, category_name: 'Water Supply' },
        { category_id: 8, category_name: 'Internet' },
        { category_id: 9, category_name: 'Faculty' },
        { category_id: 10, category_name: 'Canteen' },
        { category_id: 11, category_name: 'Other' }
    ],
    complaints: [
        { complaint_id: 1, student_id: 1, category_id: 8, title: 'Wi-Fi not working in Block-C', description: 'The Wi-Fi access points in Block-C have been non-functional for three days.', priority: 'High', status: 'Resolved', assigned_department: 'IT Department', created_at: '2026-10-25 09:30:00', updated_at: '2026-10-28 14:15:00' },
        { complaint_id: 2, student_id: 2, category_id: 1, title: 'Projector malfunction in Room 204', description: 'The projector in Classroom 204 flickers continuously during lectures.', priority: 'Medium', status: 'In Progress', assigned_department: 'Maintenance Department', created_at: '2026-10-26 11:20:00', updated_at: '2026-10-29 10:00:00' },
        { complaint_id: 3, student_id: 3, category_id: 6, title: 'Power outage in ECE lab every evening', description: 'Power trips every evening around 5 PM causing loss of simulation experiments.', priority: 'High', status: 'Pending', assigned_department: 'Electrical Department', created_at: '2026-10-27 15:45:00', updated_at: '2026-10-27 15:45:00' },
        { complaint_id: 4, student_id: 4, category_id: 7, title: 'No drinking water on 3rd floor', description: 'The water cooler on the 3rd floor of MECH block has been out of order for 2 weeks.', priority: 'Medium', status: 'Resolved', assigned_department: 'Maintenance Department', created_at: '2026-10-28 10:10:00', updated_at: '2026-10-30 16:30:00' },
        { complaint_id: 5, student_id: 5, category_id: 4, title: 'Hostel room roof leaking during rain', description: 'Room 312 roof leaks during rain, damaging student books and beds.', priority: 'High', status: 'Submitted', assigned_department: null, created_at: '2026-10-29 08:50:00', updated_at: '2026-10-29 08:50:00' },
        { complaint_id: 6, student_id: 1, category_id: 10, title: 'Canteen food quality is poor', description: 'Food hygiene standards have dropped and stale snacks are being served.', priority: 'Low', status: 'Rejected', assigned_department: 'Canteen Committee', created_at: '2026-10-29 13:00:00', updated_at: '2026-10-30 11:15:00' },
        { complaint_id: 7, student_id: 2, category_id: 5, title: 'Washrooms near Library need cleaning', description: 'The washrooms adjacent to the library need daily sanitization.', priority: 'Medium', status: 'Pending', assigned_department: 'Housekeeping Department', created_at: '2026-10-30 14:00:00', updated_at: '2026-10-30 14:00:00' },
        { complaint_id: 8, student_id: 3, category_id: 9, title: 'Faculty repeatedly absent without notice', description: 'DSA professor missed 4 consecutive lectures without substitute arrangements.', priority: 'High', status: 'In Progress', assigned_department: 'Academic Department', created_at: '2026-10-31 09:15:00', updated_at: '2026-10-31 10:30:00' }
    ],
    resolutions: [
        { resolution_id: 1, complaint_id: 1, admin_id: 1, remarks: 'Replaced dual-band Wi-Fi APs in Block-C. Signal strength restored to -48 dBm.', resolution_date: '2026-10-28 14:15:00' },
        { resolution_id: 2, complaint_id: 4, admin_id: 2, remarks: 'Replaced copper thermostat and compressor filter. Chilled water restored.', resolution_date: '2026-10-30 16:30:00' }
    ],
    history: [
        { history_id: 1, complaint_id: 1, admin_name: 'Super Admin', old_status: 'Submitted', new_status: 'Pending', remarks: 'Received and assigned to IT Department.', changed_at: '2026-10-25 10:00:00' },
        { history_id: 2, complaint_id: 1, admin_name: 'Super Admin', old_status: 'Pending', new_status: 'In Progress', remarks: 'Technician dispatched to inspect access points.', changed_at: '2026-10-26 11:00:00' },
        { history_id: 3, complaint_id: 1, admin_name: 'Super Admin', old_status: 'In Progress', new_status: 'Resolved', remarks: 'Replaced APs in Block-C. Verified operational.', changed_at: '2026-10-28 14:15:00' }
    ]
};

// Helper to parse JSON body
function parseBody(req, callback) {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
        try {
            callback(null, JSON.parse(body || '{}'));
        } catch (e) {
            callback(null, {});
        }
    });
}

function requestHandler(req, res) {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;

    // CORS & JSON Headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    // --- API ROUTES ---
    if (pathname === '/api/categories') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(db.categories));
        return;
    }

    if (pathname === '/api/student/dashboard') {
        const studentId = parseInt(parsedUrl.query.studentId || 1);
        const studentComplaints = db.complaints.filter(c => c.student_id === studentId);
        const stats = {
            total: studentComplaints.length,
            pending: studentComplaints.filter(c => c.status === 'Pending').length,
            inProgress: studentComplaints.filter(c => c.status === 'In Progress').length,
            resolved: studentComplaints.filter(c => c.status === 'Resolved').length
        };
        const student = db.students.find(s => s.student_id === studentId);
        const recent = studentComplaints.slice(0, 5).map(c => ({
            ...c,
            categoryName: (db.categories.find(cat => cat.category_id === c.category_id) || {}).category_name
        }));
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ stats, student, recent }));
        return;
    }

    if (pathname === '/api/student/complaints') {
        if (req.method === 'GET') {
            const studentId = parseInt(parsedUrl.query.studentId || 1);
            const list = db.complaints
                .filter(c => c.student_id === studentId)
                .map(c => ({
                    ...c,
                    categoryName: (db.categories.find(cat => cat.category_id === c.category_id) || {}).category_name
                }));
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(list));
            return;
        }

        if (req.method === 'POST') {
            parseBody(req, (err, data) => {
                const newId = db.complaints.length + 1;
                const now = new Date().toISOString().replace('T', ' ').substring(0, 19);
                const newComplaint = {
                    complaint_id: newId,
                    student_id: parseInt(data.studentId || 1),
                    category_id: parseInt(data.categoryId),
                    title: data.title,
                    description: data.description,
                    priority: data.priority || 'Medium',
                    status: 'Submitted',
                    assigned_department: null,
                    created_at: now,
                    updated_at: now
                };
                db.complaints.unshift(newComplaint);
                res.writeHead(201, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, complaint: newComplaint }));
            });
            return;
        }
    }

    if (pathname === '/api/admin/dashboard') {
        const stats = {
            total: db.complaints.length,
            pending: db.complaints.filter(c => c.status === 'Pending').length,
            inProgress: db.complaints.filter(c => c.status === 'In Progress').length,
            resolved: db.complaints.filter(c => c.status === 'Resolved').length,
            rejected: db.complaints.filter(c => c.status === 'Rejected').length
        };
        const totalStudents = db.students.length;
        
        // Category distribution
        const categoryStats = db.categories.map(cat => [
            cat.category_name,
            db.complaints.filter(c => c.category_id === cat.category_id).length
        ]);

        const recent = db.complaints.slice(0, 8).map(c => ({
            ...c,
            studentName: (db.students.find(s => s.student_id === c.student_id) || {}).name,
            categoryName: (db.categories.find(cat => cat.category_id === c.category_id) || {}).category_name
        }));

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ stats, totalStudents, categoryStats, recent }));
        return;
    }

    if (pathname === '/api/admin/complaints') {
        let list = db.complaints.map(c => ({
            ...c,
            studentName: (db.students.find(s => s.student_id === c.student_id) || {}).name,
            categoryName: (db.categories.find(cat => cat.category_id === c.category_id) || {}).category_name
        }));

        if (parsedUrl.query.status) {
            list = list.filter(c => c.status.toLowerCase() === parsedUrl.query.status.toLowerCase());
        }
        if (parsedUrl.query.priority) {
            list = list.filter(c => c.priority.toLowerCase() === parsedUrl.query.priority.toLowerCase());
        }
        if (parsedUrl.query.category) {
            list = list.filter(c => c.categoryName.toLowerCase() === parsedUrl.query.category.toLowerCase());
        }
        if (parsedUrl.query.search) {
            const q = parsedUrl.query.search.toLowerCase();
            list = list.filter(c => c.title.toLowerCase().includes(q) || c.studentName.toLowerCase().includes(q) || String(c.complaint_id).includes(q));
        }

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(list));
        return;
    }

    if (pathname.startsWith('/api/complaint/')) {
        const id = parseInt(pathname.replace('/api/complaint/', ''));
        const complaint = db.complaints.find(c => c.complaint_id === id);
        if (!complaint) {
            res.writeHead(404, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Complaint not found' }));
            return;
        }

        const student = db.students.find(s => s.student_id === complaint.student_id);
        const category = db.categories.find(cat => cat.category_id === complaint.category_id);
        const resolution = db.resolutions.find(r => r.complaint_id === id);
        const history = db.history.filter(h => h.complaint_id === id);

        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            ...complaint,
            studentName: student ? student.name : 'Unknown',
            categoryName: category ? category.category_name : 'General',
            resolution: resolution ? { ...resolution, adminName: (db.admins.find(a => a.admin_id === resolution.admin_id) || {}).name } : null,
            history
        }));
        return;
    }

    if (pathname === '/api/admin/updateComplaint') {
        parseBody(req, (err, data) => {
            const id = parseInt(data.complaintId);
            const complaint = db.complaints.find(c => c.complaint_id === id);
            if (!complaint) {
                res.writeHead(404, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: 'Not found' }));
                return;
            }

            const oldStatus = complaint.status;
            complaint.status = data.newStatus;
            complaint.assigned_department = data.assignedDepartment || complaint.assigned_department;
            complaint.updated_at = new Date().toISOString().replace('T', ' ').substring(0, 19);

            // Record history
            db.history.unshift({
                history_id: db.history.length + 1,
                complaint_id: id,
                admin_name: 'Super Admin',
                old_status: oldStatus,
                new_status: data.newStatus,
                remarks: data.remarks,
                changed_at: complaint.updated_at
            });

            // If resolved, create/update resolution
            if (data.newStatus === 'Resolved') {
                const existingRes = db.resolutions.find(r => r.complaint_id === id);
                if (existingRes) {
                    existingRes.remarks = data.remarks;
                    existingRes.resolution_date = complaint.updated_at;
                } else {
                    db.resolutions.push({
                        resolution_id: db.resolutions.length + 1,
                        complaint_id: id,
                        admin_id: 1,
                        remarks: data.remarks,
                        resolution_date: complaint.updated_at
                    });
                }
            }

            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ success: true, complaint }));
        });
        return;
    }

    if (pathname === '/api/admin/students') {
        let list = [...db.students];
        if (parsedUrl.query.section && parsedUrl.query.section !== 'ALL') {
            list = list.filter(s => s.section === parsedUrl.query.section);
        }
        if (parsedUrl.query.search) {
            const q = parsedUrl.query.search.toLowerCase();
            list = list.filter(s => s.name.toLowerCase().includes(q) || s.email.toLowerCase().includes(q) || (s.uid && s.uid.toLowerCase().includes(q)));
        }
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(list));
        return;
    }

    // --- STATIC FILES SERVING ---
    let filePath = path.join(PUBLIC_DIR, pathname === '/' ? 'index.html' : pathname);

    // If file doesn't exist, try appending .html
    if (!fs.existsSync(filePath) && fs.existsSync(filePath + '.html')) {
        filePath += '.html';
    }

    if (!fs.existsSync(filePath)) {
        res.writeHead(404, { 'Content-Type': 'text/html' });
        res.end('<h1>404 - Not Found</h1><p><a href="/">Return to Home</a></p>');
        return;
    }

    const ext = path.extname(filePath);
    const mimeTypes = {
        '.html': 'text/html',
        '.css': 'text/css',
        '.js': 'text/javascript',
        '.json': 'application/json',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.svg': 'image/svg+xml'
    };

    res.writeHead(200, { 'Content-Type': mimeTypes[ext] || 'text/plain' });
    fs.createReadStream(filePath).pipe(res);
}

const server = http.createServer(requestHandler);

if (require.main === module) {
    server.listen(PORT, () => {
        console.log(`=======================================================`);
        console.log(`  College Complaint System Live Preview Running!`);
        console.log(`  Access URL: http://localhost:${PORT}`);
        console.log(`=======================================================`);
    });
}

module.exports = requestHandler;
