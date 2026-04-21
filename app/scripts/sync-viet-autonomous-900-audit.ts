import { writeFile } from 'node:fs/promises';
import path from 'node:path';

import { readCsvRecords, serializeCsv, VIET_SOURCE_PATH } from './viet-expansion-lib';
import { resolveScriptRoots } from './resolve-script-roots';

const { repoRoot: REPO_ROOT } = resolveScriptRoots(import.meta.url);
const AUDIT_ROWS_PATH = path.join(REPO_ROOT, 'content-draft', 'viet', 'autonomous-900', 'generated-rows.csv');

async function main() {
  const [sourceRows, auditRows] = await Promise.all([readCsvRecords(VIET_SOURCE_PATH), readCsvRecords(AUDIT_ROWS_PATH)]);
  const sourceByPhraseId = new Map(sourceRows.map((row) => [row.phrase_id, row]));

  const syncedRows = auditRows.map((row) => {
    const sourceRow = sourceByPhraseId.get(row.phrase_id);
    return sourceRow ? { ...row, ...sourceRow } : row;
  });

  await writeFile(AUDIT_ROWS_PATH, serializeCsv(syncedRows), 'utf8');
  console.log(`Synced ${syncedRows.length} autonomous-900 audit rows from live Viet source truth.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
