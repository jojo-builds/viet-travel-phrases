const fs = require('fs');
const path = require('path');

const audioDir = path.join(__dirname, '..', 'assets', 'audio');
const files = fs.readdirSync(audioDir)
  .filter(f => f.endsWith('.mp3') && f !== 'test-vietnamese.mp3')
  .sort();

const lines = ['const audioRegistry: Record<string, number> = {'];
for (const file of files) {
  lines.push(`  "${file}": require("./${file}"),`);
}
lines.push('};');
lines.push('');
lines.push('export default audioRegistry;');
lines.push('');

const content = lines.join('\n');
fs.writeFileSync(path.join(audioDir, 'registry.ts'), content, 'utf8');
console.log(`Registry written with ${files.length} entries`);
