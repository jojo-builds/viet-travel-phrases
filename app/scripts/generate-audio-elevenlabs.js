const fs = require('fs');
const path = require('path');
const https = require('https');

// Config
const API_KEY = fs.readFileSync('C:/Users/Administrator/.openclaw/secrets/ElevenLabs.txt', 'utf8').replace('API: ', '').trim();
const VOICE_ID = 'EXAVITQu4vr4xnSDxMaL'; // Sarah - good multilingual voice
const MODEL_ID = 'eleven_v3'; // Supports Vietnamese
const AUDIO_DIR = path.join(__dirname, '..', 'assets', 'audio');

// Load scenarios
const scenarioDir = path.join(__dirname, '..', 'content', 'scenarioData');
const scenarioFiles = fs.readdirSync(scenarioDir).filter(f => f.endsWith('.ts'));

function extractPhrases() {
  const phrases = [];
  for (const file of scenarioFiles) {
    const content = fs.readFileSync(path.join(scenarioDir, file), 'utf8');
    
    // Extract all phrase objects using both single and double quote patterns
    const phraseRegex = /"vietnamese":\s*"([^"]+)"/g;
    const audioKeyRegex = /"audioKey":\s*"([^"]+)"/g;
    
    const vietnameseTexts = [];
    const audioKeys = [];
    let match;
    
    while ((match = phraseRegex.exec(content)) !== null) {
      vietnameseTexts.push(match[1]);
    }
    while ((match = audioKeyRegex.exec(content)) !== null) {
      audioKeys.push(match[1]);
    }
    
    for (let i = 0; i < vietnameseTexts.length; i++) {
      phrases.push({
        vietnamese: vietnameseTexts[i],
        audioKey: audioKeys[i] || `unknown-${i + 1}`,
      });
    }
  }
  return phrases;
}

function generateAudio(text, outputPath) {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      text: text,
      model_id: MODEL_ID,
      voice_settings: { stability: 0.75, similarity_boost: 0.75, speed: 0.85 },
      language_code: 'vi',
    });

    const options = {
      hostname: 'api.elevenlabs.io',
      path: `/v1/text-to-speech/${VOICE_ID}`,
      method: 'POST',
      headers: {
        'xi-api-key': API_KEY,
        'Content-Type': 'application/json',
        'Accept': 'audio/mpeg',
        'Content-Length': Buffer.byteLength(body),
      },
    };

    const req = https.request(options, (res) => {
      if (res.statusCode !== 200) {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => reject(new Error(`HTTP ${res.statusCode}: ${data}`)));
        return;
      }
      const chunks = [];
      res.on('data', chunk => chunks.push(chunk));
      res.on('end', () => {
        fs.writeFileSync(outputPath, Buffer.concat(chunks));
        resolve();
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function main() {
  if (!fs.existsSync(AUDIO_DIR)) {
    fs.mkdirSync(AUDIO_DIR, { recursive: true });
  }

  const phrases = extractPhrases();
  console.log(`Found ${phrases.length} phrases to generate audio for.\n`);

  let generated = 0;
  let skipped = 0;
  let failed = 0;

  for (let i = 0; i < phrases.length; i++) {
    const phrase = phrases[i];
    const filename = `${phrase.audioKey}.mp3`;
    const outputPath = path.join(AUDIO_DIR, filename);

    if (fs.existsSync(outputPath) && fs.statSync(outputPath).size > 1000) {
      console.log(`[${i + 1}/${phrases.length}] SKIP (exists): ${filename}`);
      skipped++;
      continue;
    }

    try {
      console.log(`[${i + 1}/${phrases.length}] Generating: ${filename} — "${phrase.vietnamese}"`);
      await generateAudio(phrase.vietnamese, outputPath);
      const size = fs.statSync(outputPath).size;
      console.log(`  → OK (${(size / 1024).toFixed(1)} KB)`);
      generated++;
      // Rate limit: 500ms between requests
      await new Promise(r => setTimeout(r, 500));
    } catch (err) {
      console.error(`  → FAILED: ${err.message}`);
      failed++;
    }
  }

  console.log(`\nDone! Generated: ${generated}, Skipped: ${skipped}, Failed: ${failed}`);
  console.log(`Total audio files: ${fs.readdirSync(AUDIO_DIR).filter(f => f.endsWith('.mp3')).length}`);
}

main().catch(console.error);
