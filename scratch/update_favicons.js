const fs = require('fs');
const path = require('path');

function updateHtml(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');

  const newFaviconBlock = [
    '    <link rel="icon" type="image/x-icon" href="/favicon.ico?v=20261101">',
    '    <link rel="icon" type="image/png" sizes="32x32" href="/images/favicon-32x32.png?v=20261101">',
    '    <link rel="icon" type="image/png" sizes="16x16" href="/images/favicon-16x16.png?v=20261101">',
    '    <link rel="apple-touch-icon" sizes="180x180" href="/images/apple-touch-icon.png?v=20261101">',
    '    <link rel="manifest" href="/site.webmanifest">'
  ].join('\n');

  // Replace old favicon links
  content = content.replace(/(?:[ \t]*<link rel="(?:icon|shortcut icon|apple-touch-icon)"[^>]*>\r?\n?)+/g, newFaviconBlock + '\n');

  // Replace img src with cache buster
  content = content.replace(/src="\/images\/cu_logo\.png(?:\?v=[^"]*)?"/g, 'src="/images/cu_logo.png?v=20261101"');

  fs.writeFileSync(filePath, content, 'utf8');
}

function updateJsp(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');

  const newJspFaviconBlock = [
    '    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=20261101">',
    '    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/favicon-32x32.png?v=20261101">',
    '    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/images/favicon-16x16.png?v=20261101">',
    '    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/images/apple-touch-icon.png?v=20261101">'
  ].join('\n');

  content = content.replace(/(?:[ \t]*<link rel="(?:icon|shortcut icon|apple-touch-icon)"[^>]*>\r?\n?)+/g, newJspFaviconBlock + '\n');
  content = content.replace(/src="\$\{pageContext\.request\.contextPath\}\/images\/cu_logo\.png(?:\?v=[^"]*)?"/g, 'src="${pageContext.request.contextPath}/images/cu_logo.png?v=20261101"');

  fs.writeFileSync(filePath, content, 'utf8');
}

const htmlDirs = [
  'CollegeComplaintSystem/public',
  'CollegeComplaintSystem/preview/public'
];

htmlDirs.forEach(dir => {
  if (fs.existsSync(dir)) {
    fs.readdirSync(dir).filter(f => f.endsWith('.html')).forEach(f => {
      updateHtml(path.join(dir, f));
      console.log('Updated HTML:', path.join(dir, f));
    });
  }
});

const jspDir = 'CollegeComplaintSystem/src/main/webapp';
if (fs.existsSync(jspDir)) {
  fs.readdirSync(jspDir).filter(f => f.endsWith('.jsp')).forEach(f => {
    updateJsp(path.join(jspDir, f));
    console.log('Updated JSP:', path.join(jspDir, f));
  });
}
console.log('All files updated successfully!');
