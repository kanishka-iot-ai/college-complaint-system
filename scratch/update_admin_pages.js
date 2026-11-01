const fs = require('fs');
const path = require('path');

const adminPages = [
  'admin_dashboard.html',
  'admin_all_complaints.html',
  'admin_complaint_detail.html',
  'admin_students.html',
  'admin_reports.html'
];

const dirs = [
  'CollegeComplaintSystem/public',
  'CollegeComplaintSystem/preview/public'
];

dirs.forEach(dir => {
  adminPages.forEach(file => {
    const p = path.join(dir, file);
    if (!fs.existsSync(p)) return;
    let content = fs.readFileSync(p, 'utf8');

    // Replace navbar sign out
    content = content.replace(
      /<span style="font-size: 0\.95rem; color: var\(--slate\);">Logged as: <strong>Super Admin<\/strong><\/span>\s*<a href="\/admin_login\.html" class="btn btn-outline btn-sm">Sign Out<\/a>/,
      '<span style="font-size: 0.95rem; color: var(--slate);">Logged as: <strong id="adminNameDisplay">Super Admin</strong></span>\n            <button type="button" onclick="handleAdminSignOut()" class="btn btn-outline btn-sm">Sign Out</button>'
    );

    // Add session script if not present
    if (!content.includes('function handleAdminSignOut')) {
      const scriptBlock = '\n    <script>\n' +
        '        const adminUser = JSON.parse(localStorage.getItem("admin_user") || "null");\n' +
        '        if (!adminUser) {\n' +
        '            window.location.href = "/admin_login.html";\n' +
        '        } else if (document.getElementById("adminNameDisplay")) {\n' +
        '            document.getElementById("adminNameDisplay").textContent = adminUser.name || "Administrator";\n' +
        '        }\n\n' +
        '        function handleAdminSignOut() {\n' +
        '            localStorage.removeItem("admin_user");\n' +
        '            window.location.href = "/admin_login.html";\n' +
        '        }\n' +
        '    </script>\n';

      content = content.replace('</body>', scriptBlock + '</body>');
    }

    fs.writeFileSync(p, content, 'utf8');
    console.log('Updated admin page:', p);
  });
});
