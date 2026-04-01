const fs = require('fs');
const path = require('path');
const dir = path.join(__dirname, '..', 'content', 'scenarioData');
const files = fs.readdirSync(dir).filter(f => f.endsWith('.ts')).sort();

for (const file of files) {
  const content = fs.readFileSync(path.join(dir, file), 'utf8');
  const nameMatch = content.match(/"name":\s*"([^"]+)"/);
  console.log('\n=== ' + (nameMatch ? nameMatch[1] : file) + ' ===');
  const regex = /"vietnamese":\s*"([^"]+)"\s*,\s*"romanized":\s*"([^"]+)"\s*,\s*"english":\s*"([^"]+)"/g;
  let m;
  while ((m = regex.exec(content)) !== null) {
    console.log(m[1] + '  |  ' + m[3]);
  }
}
